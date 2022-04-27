import Foundation

enum ConversationTransformer {
    static func transform(data: RemoteConversationList) -> [Conversation] {
        data.conversations.conversations.map { conversation in
            transform(fragment: conversation.fragments.conversationFragment)
        }
    }
    
    static func transform(fragment: RemoteConversation) -> Conversation {
        Conversation(
            id: fragment.id,
            avatarURL: fragment.providers.first?.fragments.providerInConversationFragment.provider.fragments.providerFragment.avatarUrl?.fragments.ephemeralUrlFragment.url,
            initials: nil,
            title: fragment.title,
            lastMessagePreview: fragment.lastMessagePreview,
            lastUpdatedTime: fragment.updatedAt,
            isUnread: fragment.unreadMessageCount > 0
        )
    }
}
