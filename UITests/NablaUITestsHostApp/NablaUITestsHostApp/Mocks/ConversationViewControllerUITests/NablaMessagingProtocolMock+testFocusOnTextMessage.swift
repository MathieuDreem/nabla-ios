import Foundation
@testable import NablaCore
@testable import NablaMessagingCore

extension NablaMessagingClientProtocolMock {
    func setupForTestFocusOnTextMessage() {
        setupForTestCreateConversation()

        watchConversationClosure = { _, handler in
            handler(.success(.mock()))
            return WatcherMock()
        }

        watchItemsClosure = { _, handler in
            handler(.success(.init(
                hasMore: false,
                items: [
                    TextMessageItem(
                        id: .init(),
                        date: .init(),
                        sender: .me,
                        sendingState: .sent,
                        replyTo: nil,
                        content: "World!"
                    ),
                    TextMessageItem(
                        id: .init(),
                        date: .init(),
                        sender: .me,
                        sendingState: .sent,
                        replyTo: nil,
                        content: "Hello"
                    ),
                ]
            )))
            return PaginatedWatcherMock()
        }
    }
}
