import Foundation

@MainActor
class EditEventViewModel: ObservableObject {

    @Published var editEventRequest: EditEventDTO = .init()
        @Published var isLoading: Bool = false
        @Published var error: String?
        var updatedEvent: EventResponse?

        let eventId: UUID

        init(eventId: UUID) {
            self.eventId = eventId
        }

        func fetchEventDetails() async {
            isLoading = true
            error = nil
            do {
                let event = try await EventService.getEventById(eventId: eventId)
                print(event)
                self.editEventRequest = event
            } catch {
                self.error = "Failed to load event: \(error.localizedDescription)"
            }
            isLoading = false
        }
  


    func submit() async {
        isLoading = true
        error = nil

        let validationResult = EditEventValidator.validate(editEventRequest)

        if validationResult.isFailure {
            self.error = validationResult.errorMessages.first
            self.isLoading = false
            return
        }

        do {
            updatedEvent = try await EventService.editEvent(newEvent: editEventRequest)
        } catch {
            self.error = "Failed to update event: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
