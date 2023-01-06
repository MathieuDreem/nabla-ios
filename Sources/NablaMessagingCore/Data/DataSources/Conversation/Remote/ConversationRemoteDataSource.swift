import Combine
import Foundation
import NablaCore

// sourcery: AutoMockable
protocol ConversationRemoteDataSource {
    func createConversation(
        message: GQL.SendMessageInput?,
        title: String?,
        providerIds: [UUID]?
    ) async throws -> RemoteConversation
    
    func setIsTyping(_ isTyping: Bool, conversationId: UUID) async throws
    
    func markConversationAsSeen(conversationId: UUID) async throws
    
    func watchConversation(_ conversationId: UUID) -> AnyPublisher<RemoteConversation, GQLError>
    
    func watchConversations() -> AnyPublisher<PaginatedList<RemoteConversation>, GQLError>
    
    func subscribeToConversationsEvents() -> AnyPublisher<RemoteConversationsEvent, Never>
}
