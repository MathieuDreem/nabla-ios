import Combine
import Foundation
import NablaCore

protocol AvailabilitySlotRepository {
    func watchCategories() -> AnyPublisher<[Category], NablaError>
    func watchAvailabilitySlots(forCategoryWithId: UUID) -> AnyPublisher<PaginatedList<AvailabilitySlot>, NablaError>
}
