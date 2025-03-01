import Foundation

public enum UploadClientError: Error {
    case noAccessToken
    case impossibleToBuildFormData
    case noValidData
    case failedToSerializePurpose
}

public struct UploadData {
    public let purpose: String
    public let content: Data
    public let fileName: String
    public let mimeType: MimeType
    
    public init(
        purpose: String,
        content: Data,
        fileName: String,
        mimeType: MimeType
    ) {
        self.purpose = purpose
        self.content = content
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

public final class UploadClient {
    // MARK: - Initializer

    init(
        httpManager: HTTPManager,
        authenticator: Authenticator
    ) {
        self.httpManager = httpManager
        self.authenticator = authenticator
    }

    // MARK: - Public
    
    public func upload(_ data: UploadData, handler: ResultHandler<UUID, UploadClientError>) -> Cancellable {
        let umbrella = UmbrellaCancellable()
        
        authenticator.getAccessToken(
            handler: .init { [weak self, weak umbrella] result in
                guard let self = self, let umbrella = umbrella, !umbrella.isCancelled else { return }
                guard let state = result.nabla.value else {
                    handler(.failure(.noAccessToken))
                    return
                }
                switch state {
                case let .authenticated(accessToken: token):
                    let task = self.doUpload(authToken: token, data: data, handler: handler)
                    umbrella.add(task)
                case .notAuthenticated:
                    handler(.failure(.noAccessToken))
                }
            })
        
        return umbrella
    }
    
    // MARK: - Private
    
    private let httpManager: HTTPManager
    private let authenticator: Authenticator
    
    private func makeHeaders(authToken: String) -> [String: String] {
        [
            HTTPHeaders.Accept: "application/json",
            HTTPHeaders.NablaAuthorization: "Bearer \(authToken)",
        ]
    }
    
    private func makeMultipartFormData(data: UploadData) -> Result<MultipartFormData.BuildResult, UploadClientError> {
        guard
            let purpose = data.purpose.data(using: .utf8)
        else {
            return .failure(UploadClientError.failedToSerializePurpose)
        }
        do {
            let multipartFormData = try MultipartFormData.Builder.build(
                with: [
                    (
                        name: "purpose",
                        filename: nil,
                        mimeType: nil,
                        data: purpose
                    ),
                    (
                        name: "file",
                        filename: data.fileName,
                        mimeType: Self.makeMimeType(from: data.mimeType),
                        data: data.content
                    ),
                ],
                willSeparateBy: RandomBoundaryGenerator.generate()
            )
            return .success(multipartFormData)
        } catch {
            return .failure(.impossibleToBuildFormData)
        }
    }
    
    private func doUpload(
        authToken: String,
        data: UploadData,
        handler: ResultHandler<UUID, UploadClientError>
    ) -> Cancellable {
        var request = UploadEndpoint.request()
        var headers = makeHeaders(authToken: authToken)
        var body: Data?
        
        switch makeMultipartFormData(data: data) {
        case let .success(multipartFormData):
            headers[HTTPHeaders.ContentType] = multipartFormData.contentType
            body = multipartFormData.body
        case .failure:
            handler(.failure(.impossibleToBuildFormData))
            return Failure()
        }
        
        request = request.headers(headers)
        request = request.body(body)
        
        return httpManager.fetch(UploadEndpoint.Result.self, associatedTo: request) { result in
            guard
                let uuidString = result.nabla.value?.first,
                let uuid = UUID(uuidString: uuidString)
            else {
                handler(.failure(.noValidData))
                return
            }
            handler(.success(uuid))
        }
    }
    
    private static func makeMimeType(from mimeType: MimeType) -> MIMEType {
        switch mimeType {
        case let .image(imageType):
            switch imageType {
            case .png: return MIMEType.imagePng
            case .jpg: return MIMEType.imageJpeg
            case .heic: return MIMEType(text: "image/heic")
            case .heif: return MIMEType(text: "image/heif")
            case .other: return MIMEType(text: "image/*")
            }
        case let .video(videoType):
            switch videoType {
            case .mov: return MIMEType(text: "video/mov")
            case .mp4: return MIMEType(text: "video/mp4")
            case .other: return MIMEType(text: "video/*")
            }
        case let .audio(audioType):
            switch audioType {
            case .mpeg: return MIMEType.audioMpeg
            case .other: return MIMEType(text: "audio/*")
            }
        case let .document(documentType):
            switch documentType {
            case .pdf: return MIMEType(text: "application/pdf")
            case .other: return MIMEType(text: "application/*")
            }
        }
    }
}
