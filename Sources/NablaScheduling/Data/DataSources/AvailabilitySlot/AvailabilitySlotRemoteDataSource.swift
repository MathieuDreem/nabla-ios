import Combine
import Foundation
import NablaCore

public struct PaginatedList<T> {
    public let data: [T]
    public let hasMore: Bool
    public let loadMore: (() async throws -> Void)?
}

protocol AvailabilitySlotRemoteDataSource {
    func watchCategories() -> AnyPublisher<[RemoteCategory], GQLError>
    func watchAvailabilitySlots(forCategoryWithId: UUID) -> AnyPublisher<PaginatedList<RemoteAvailabilitySlot>, GQLError>
}
