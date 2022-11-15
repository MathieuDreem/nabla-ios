import Combine
import Foundation
import NablaCore

public final class NablaSchedulingClient: SchedulingClient {
    // MARK: - Public
    
    public func watchAppointments(state: Appointment.State) -> AnyPublisher<PaginatedList<Appointment>, NablaError> {
        container.watchAppointmentsInteractor.execute(state: state)
    }
    
    public func watchCategories() -> AnyPublisher<[Category], NablaError> {
        container.watchCategoriesInteractor.execute()
    }
    
    public func watchAvailabilitySlots(forCategoryWithId categoryId: UUID) -> AnyPublisher<PaginatedList<AvailabilitySlot>, NablaError> {
        container.watchAvailabilitySlotsInteractor.execute(categoryId: categoryId)
    }

    public func watchProvider(id: UUID) -> AnyPublisher<Provider, NablaError> {
        container.watchProviderInteractor.execute(providerId: id)
    }
    
    /// Throws `NablaError`
    public func scheduleAppointment(categoryId: UUID, providerId: UUID, date: Date) async throws -> Appointment {
        try await container.scheduleAppointmentInteractor.execute(categoryId: categoryId, providerId: providerId, date: date)
    }
    
    /// Throws `NablaError`
    public func cancelAppointment(withId appointmentId: UUID) async throws {
        try await container.cancelAppointmentInteractor.execute(appointmentId: appointmentId)
    }
    
    // MARK: Initializer
    
    public init(
        container: CoreContainer
    ) {
        self.container = NablaSchedulingContainer(
            coreContainer: container
        )
    }
    
    // MARK: - Internal
    
    let container: NablaSchedulingContainer
        
    // MARK: - Private
}
