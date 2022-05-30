// swiftlint:disable large_tuple
import Foundation
import NablaMessagingCore
@testable import NablaMessagingUI

final class NablaMessagingClientProtocolMock: NablaMessagingClientProtocol {
    var logger: Logger = LoggerMock()

    var createConversationReceivedInvocations: [(handler: (Result<Conversation, NablaError>) -> Void, Void)] = []
    var createConversationClosure: ((_ handler: @escaping (Result<Conversation, NablaError>) -> Void) -> Cancellable)?
    func createConversation(
        handler: @escaping (Result<Conversation, NablaError>) -> Void
    ) -> Cancellable {
        createConversationReceivedInvocations.append((handler: handler, ()))
        return createConversationClosure?(handler) ?? CancellableMock()
    }

    var watchItemsReceivedInvocations: [(conversationId: UUID, handler: (Result<ConversationItems, NablaError>) -> Void)] = []
    var watchItemsClosure: ((_ conversationId: UUID, _ handler: @escaping (Result<ConversationItems, NablaError>) -> Void) -> PaginatedWatcher)?
    func watchItems(
        ofConversationWithId conversationId: UUID,
        handler: @escaping (Result<ConversationItems, NablaError>) -> Void
    ) -> PaginatedWatcher {
        watchItemsReceivedInvocations.append((conversationId: conversationId, handler: handler))
        return watchItemsClosure?(conversationId, handler) ?? PaginatedWatcherMock()
    }

    var setIsTypingReceivedInvocations: [(isTyping: Bool, conversationId: UUID, handler: (Result<Void, NablaError>) -> Void)] = []
    var setIsTypingClosure: ((_ isTyping: Bool, _ conversationId: UUID, _ handler: @escaping (Result<Void, NablaError>) -> Void) -> Cancellable)?
    func setIsTyping(
        _ isTyping: Bool,
        inConversationWithId conversationId: UUID,
        handler: @escaping (Result<Void, NablaError>) -> Void
    ) -> Cancellable {
        setIsTypingReceivedInvocations.append((isTyping: isTyping, conversationId: conversationId, handler: handler))
        return setIsTypingClosure?(isTyping, conversationId, handler) ?? CancellableMock()
    }

    var markConversationAsSeenReceivedInvocations: [(conversationId: UUID, handler: (Result<Void, NablaError>) -> Void)] = []
    var markConversationAsSeenClosure: ((_ conversationId: UUID, _ handler: @escaping (Result<Void, NablaError>) -> Void) -> Cancellable)?
    func markConversationAsSeen(
        _ conversationId: UUID,
        handler: @escaping (Result<Void, NablaError>) -> Void
    ) -> Cancellable {
        markConversationAsSeenReceivedInvocations.append((conversationId: conversationId, handler: handler))
        return markConversationAsSeenClosure?(conversationId, handler) ?? CancellableMock()
    }

    var watchConversationsParams: [(handler: (Result<ConversationList, NablaError>) -> Void, Void)] = []
    var watchConversationsClosure: ((_ handler: @escaping (Result<ConversationList, NablaError>) -> Void) -> PaginatedWatcher)?
    func watchConversations(
        handler: @escaping (Result<ConversationList, NablaError>) -> Void
    ) -> PaginatedWatcher {
        watchConversationsParams.append((handler: handler, ()))
        return watchConversationsClosure?(handler) ?? PaginatedWatcherMock()
    }

    var watchConversationParams: [(conversationId: UUID, handler: (Result<Conversation, NablaError>) -> Void)] = []
    var watchConversationClosure: ((_ conversationId: UUID, _ handler: @escaping (Result<Conversation, NablaError>) -> Void) -> Cancellable)?
    func watchConversation(
        _ conversationId: UUID,
        handler: @escaping (Result<Conversation, NablaError>) -> Void
    ) -> Cancellable {
        watchConversationParams.append((conversationId: conversationId, handler: handler))
        return watchConversationClosure?(conversationId, handler) ?? CancellableMock()
    }

    var sendMessageParams: [(message: MessageInput, conversationId: UUID, handler: (Result<Void, NablaError>) -> Void)] = []
    var sendMessageClosure: ((_ message: MessageInput,
                              _ conversationId: UUID,
                              _ handler: @escaping (Result<Void, NablaError>) -> Void) -> Cancellable)?
    func sendMessage(
        _ message: MessageInput,
        inConversationWithId conversationId: UUID,
        handler: @escaping (Result<Void, NablaError>) -> Void
    ) -> Cancellable {
        sendMessageParams.append((message: message, conversationId: conversationId, handler: handler))
        return sendMessageClosure?(message, conversationId, handler) ?? CancellableMock()
    }

    var retrySendingParams: [(itemId: UUID, conversationId: UUID, handler: (Result<Void, NablaError>) -> Void)] = []
    var retrySendingClosure: ((_ itemId: UUID, _ conversationId: UUID, _ handler: @escaping (Result<Void, NablaError>) -> Void) -> Cancellable)?
    func retrySending(
        itemWithId itemId: UUID,
        inConversationWithId conversationId: UUID,
        handler: @escaping (Result<Void, NablaError>) -> Void
    ) -> Cancellable {
        retrySendingParams.append((itemId: itemId, conversationId: conversationId, handler: handler))
        return retrySendingClosure?(itemId, conversationId, handler) ?? CancellableMock()
    }

    var deleteMessageParams: [(messageId: UUID, conversationId: UUID, handler: (Result<Void, NablaError>) -> Void)] = []
    var deleteMessageClosure: ((_ messageId: UUID, _ conversationId: UUID, _ handler: @escaping (Result<Void, NablaError>) -> Void) -> Cancellable)?
    func deleteMessage(
        withId messageId: UUID,
        conversationId: UUID,
        handler: @escaping (Result<Void, NablaError>) -> Void
    ) -> Cancellable {
        deleteMessageParams.append((messageId: messageId, conversationId: conversationId, handler: handler))
        return deleteMessageClosure?(messageId, conversationId, handler) ?? CancellableMock()
    }
}

extension NablaMessagingClientProtocolMock {
    static var shared = NablaMessagingClientProtocolMock()
}
