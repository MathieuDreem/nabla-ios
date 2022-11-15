import Foundation

public struct AvailabilitySlot: Equatable {
    public let start: Date
    public let end: Date
    public let providerId: UUID
}
