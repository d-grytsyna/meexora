import Foundation

@MainActor
class EventUserInfoViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var isAvailable: Bool?
    @Published var errorMessage: String?

    func checkAvailability(for eventId: UUID) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await BookingService.checkAvailability(eventId: eventId)
            isAvailable = result
        } catch {
            errorMessage = "Failed to check ticket availability"
            isAvailable = nil
        }
    }
}

