import Foundation
@testable import NablaCore
@testable import NablaMessagingCore

extension NablaMessagingClientProtocolMock {
    func setupForTestSendMessageAndDelete() {
        setupForTestCreateConversation()

        watchConversationClosure = { _, handler in
            handler(.success(.mock()))
            return WatcherMock()
        }

        watchItemsClosure = { _, handler in
            handler(.success(.init(
                hasMore: false,
                items: []
            )))
            return PaginatedWatcherMock()
        }

        var textContent = ""
        let textMessageId = UUID()

        sendMessageClosure = { message, _, _ in
            if case let .text(content) = message {
                textContent = content
            }
            self.watchItemsReceivedInvocations.forEach { params in
                params.handler(.success(.init(
                    hasMore: false,
                    items: [
                        TextMessageItem(
                            id: textMessageId,
                            date: Date(),
                            sender: .me,
                            sendingState: .sent,
                            replyTo: nil,
                            content: textContent
                        ),
                    ]
                )))
            }
            return PaginatedWatcherMock()
        }

        deleteMessageClosure = { _, _, _ in
            self.watchItemsReceivedInvocations.forEach { invocation in
                invocation.handler(.success(.init(
                    hasMore: false,
                    items: [
                        DeletedMessageItem(id: .init(), date: .init(), sender: .me, sendingState: .sent, replyTo: nil),
                    ]
                )))
            }
            return PaginatedWatcherMock()
        }
    }
}
