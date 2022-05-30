import Foundation
@testable import NablaMessagingCore

extension NablaMessagingClientProtocolMock {
    func setupForTestTypingIndicatorAppears() {
        setupForTestCreateConversation()

        watchConversationClosure = { _, handler in
            let conversation: Conversation = .mock()
            handler(.success(conversation))
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                handler(.success(Conversation(
                    id: conversation.id,
                    title: conversation.title,
                    description: conversation.description,
                    inboxPreviewTitle: conversation.inboxPreviewTitle,
                    lastMessagePreview: conversation.lastMessagePreview,
                    lastModified: conversation.lastModified,
                    patientUnreadMessageCount: conversation.patientUnreadMessageCount,
                    providers: [
                        .init(
                            provider: .init(id: .init(), avatarURL: nil, prefix: "Dr", firstName: "John", lastName: "Doe"),
                            typingAt: Date(),
                            seenUntil: Date()
                        ),
                    ]
                )))
            }
            return CancellableMock()
        }

        watchItemsClosure = { _, handler in
            handler(.success(.init(
                conversationId: .init(),
                hasMore: false,
                items: []
            )))
            return PaginatedWatcherMock()
        }
    }
}
