import Foundation

public struct Conversation {
    public let id: UUID
    public let title: String?
    public let subtitle: String?
    public let inboxPreviewTitle: String
    public let lastMessagePreview: String?
    public let lastModified: Date
    public let patientUnreadMessageCount: Int
    public let pictureUrl: URL?
    public let providers: [ProviderInConversation]
    
    public init(
        id: UUID,
        title: String?,
        subtitle: String?,
        inboxPreviewTitle: String,
        lastMessagePreview: String?,
        lastModified: Date,
        patientUnreadMessageCount: Int,
        pictureUrl: URL?,
        providers: [ProviderInConversation]
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.inboxPreviewTitle = inboxPreviewTitle
        self.lastMessagePreview = lastMessagePreview
        self.lastModified = lastModified
        self.patientUnreadMessageCount = patientUnreadMessageCount
        self.pictureUrl = pictureUrl
        self.providers = providers
    }
}
