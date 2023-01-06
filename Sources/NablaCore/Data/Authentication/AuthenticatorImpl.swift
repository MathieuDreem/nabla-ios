import Foundation

class AuthenticatorImpl: Authenticator {
    // MARK: - Initialiazer

    init(httpManager: HTTPManager) {
        self.httpManager = httpManager
    }

    // MARK: - Internal
    
    func authenticate(
        userId: String,
        provider: SessionTokenProvider
    ) {
        session = Session(
            userId: userId,
            provider: provider,
            tokens: nil
        )
    }
    
    func logOut() {
        let oldTokens = session?.tokens
        session = nil
        notifyTokensChanged(oldValue: oldTokens, newValue: nil)
    }
    
    func getAccessToken() async throws -> AuthenticationState {
        guard let session = session else {
            return .notAuthenticated
        }
        
        if let tokens = session.tokens, !tokens.accessToken.isExpired {
            return .authenticated(accessToken: tokens.accessToken.value)
        }
        
        let task = makeOrReuseRenewSessionTask(session: session)
        switch await task.result {
        case let .failure(error):
            if let authError = error as? AuthenticationError {
                throw authError
            } else {
                throw UnknownAuthenticationError(undelryingError: error)
            }
        case let .success(tokens):
            let oldTokens = session.tokens
            session.tokens = tokens
            notifyTokensChanged(oldValue: oldTokens, newValue: tokens)
            return .authenticated(accessToken: tokens.accessToken.value)
        }
    }
    
    func addObserver(_ observer: Any, selector: Selector) {
        notificationCenter.addObserver(
            observer,
            selector: selector,
            name: Constants.tokenChangedNotification,
            object: nil
        )
    }
    
    func removeObserver(_ observer: Any) {
        notificationCenter.removeObserver(
            observer,
            name: Constants.tokenChangedNotification,
            object: nil
        )
    }

    func isSessionInitialized() -> Bool {
        session != nil
    }

    // MARK: - Private
    
    private enum Constants {
        static let tokenChangedNotification = Notification.Name(rawValue: "tokenChangedNotification")
    }
    
    private let notificationCenter = NotificationCenter()
    private let httpManager: HTTPManager
    
    private var session: Session?
    private var renewTask: Task<SessionTokens, Error>?
    
    private func makeOrReuseRenewSessionTask(session: Session) -> Task<SessionTokens, Error> {
        if let existing = renewTask {
            return existing
        }
        let renewTask = Task<SessionTokens, Error> {
            do {
                let tokens = try await renewSession(session)
                self.renewTask = nil
                return tokens
            } catch {
                self.renewTask = nil
                throw error
            }
        }
        self.renewTask = renewTask
        return renewTask
    }
    
    private func notifyTokensChanged(oldValue: SessionTokens?, newValue: SessionTokens?) {
        guard newValue != oldValue else { return }
        notificationCenter.post(name: Constants.tokenChangedNotification, object: nil)
    }
    
    /// - Throws: ``AuthenticationError``
    private func renewSession(_ session: Session) async throws -> SessionTokens {
        if let tokens = session.tokens, !tokens.refreshToken.isExpired {
            return try await fetchTokens(refreshToken: tokens.refreshToken)
        }
        return try await requireTokens(session: session)
    }
    
    /// - Throws: ``AuthenticationError``
    private func requireTokens(session: Session) async throws -> SessionTokens {
        let authTokens = await withCheckedContinuation { (continuation: CheckedContinuation<AuthTokens?, Never>) in
            session.provider.provideTokens(forUserId: session.userId) { authTokens in
                continuation.resume(returning: authTokens)
            }
        }
        guard let authTokens = authTokens else {
            throw AuthenticationProviderFailedToProvideTokensError()
        }
        
        do {
            let accessToken = try Self.deserialize(token: authTokens.accessToken)
            let refreshToken = try Self.deserialize(token: authTokens.refreshToken)
            
            if refreshToken.isExpired {
                throw AuthenticationProviderDidProvideExpiredTokensError()
            } else if accessToken.isExpired {
                return try await fetchTokens(refreshToken: refreshToken)
            } else {
                return SessionTokens(accessToken: accessToken, refreshToken: refreshToken)
            }
        } catch let error as AuthenticationError {
            throw error
        } catch {
            throw UnknownAuthenticationError(undelryingError: error)
        }
    }
    
    /// - Throws: ``AuthenticationError``
    private func fetchTokens(refreshToken: Token) async throws -> SessionTokens {
        let request = RefreshTokenEndpoint.request(refreshToken: refreshToken.value)
        do {
            let response = try await httpManager.fetch(RefreshTokenEndpoint.Response.self, associatedTo: request)
            
            let accessToken = try Self.deserialize(token: response.accessToken)
            let refreshToken = try Self.deserialize(token: response.refreshToken)
            return SessionTokens(
                accessToken: accessToken,
                refreshToken: refreshToken
            )
        } catch let error as HTTPError {
            if Self.isAuthorizationError(error) {
                throw AuthorizationDeniedError(reason: error)
            } else {
                throw FailedToRefreshTokensError(reason: error)
            }
        } catch let error as AuthenticationError {
            throw error
        } catch {
            throw UnknownAuthenticationError(undelryingError: error)
        }
    }
    
    private static func isAuthorizationError(_ error: HTTPError) -> Bool {
        switch error {
        case .transportError, .decodingError, .noSelf:
            return false
        case let .serverError(serverError):
            switch serverError {
            case .unauthorized:
                return true
            case .generic, .notFound, .unavailableService:
                return false
            }
        }
    }
    
    private static func deserialize(token: String) throws -> Token {
        do {
            let jwt = try decode(jwt: token)
            return Token(value: token, expiresAt: jwt.expiresAt)
        } catch {
            throw AuthenticationProviderDidProvideInvalidTokensError(reason: error)
        }
    }
}
