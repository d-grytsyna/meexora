import Foundation

@MainActor
class CreateEventViewModel: ObservableObject {
    @Published var newEventRequest: CreateEventRequest = CreateEventRequest()
    var createdEvent: EventResponse?
    @Published var isLoading: Bool = false
    @Published var error: String?
    

    func submit() async {
        isLoading = true
        error = nil
        
        let validationResult = CreateEventValidator.validate(newEventRequest)
        
        if validationResult.isFailure {
            self.error = validationResult.errorMessages.first
            self.isLoading = false
            return
        }
        
        do {
            createdEvent = try await EventService.createEvent(newEvent: newEventRequest)
           
            
        } catch {
            self.error = "Failed to create new event : \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
