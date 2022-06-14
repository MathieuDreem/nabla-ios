import Foundation
@testable import NablaMessagingCore

extension NablaMessagingClientProtocolMock {
    func setupForTestFocusOnTextMessage() {
        setupForTestCreateConversation()

        watchConversationClosure = { _, handler in
            handler(.success(.mock()))
            return CancellableMock()
        }

        watchItemsClosure = { _, handler in
            handler(.success(.init(
                conversationId: .init(),
                hasMore: false,
                items: [
                    TextMessageItem(
                        id: .init(),
                        date: .init(),
                        sender: .patient,
                        sendingState: .sent,
                        replyTo: nil,
                        content: "Hello"
                    ),
                    TextMessageItem(
                        id: .init(),
                        date: .init(),
                        sender: .patient,
                        sendingState: .sent,
                        replyTo: nil,
                        content: "World!"
                    ),
                ]
            )))
            return PaginatedWatcherMock()
        }
    }
}
