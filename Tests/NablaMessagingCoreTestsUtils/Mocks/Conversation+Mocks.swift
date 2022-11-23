import Foundation
@testable import NablaMessagingCore

public extension Conversation {
    static func mock(
        pictureUrl: URL? = nil,
        providers: [ProviderInConversation] = []
    ) -> Conversation {
        conversationCount += 1
        return Conversation(
            id: .init(),
            title: "Title \(conversationCount)",
            subtitle: "Subtitle \(conversationCount)",
            inboxPreviewTitle: "PreviewTitle \(conversationCount)",
            lastMessagePreview: "MessagePreview \(conversationCount)",
            lastModified: .init(timeIntervalSinceReferenceDate: 0),
            patientUnreadMessageCount: 0,
            pictureUrl: pictureUrl,
            providers: providers,
            isLocked: false
        )
    }
    
    private static var conversationCount = 0
}
