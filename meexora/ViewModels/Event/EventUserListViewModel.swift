import Foundation

@MainActor
final class EventUserListViewModel: ObservableObject {
    @Published var events: [EventShortResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchEvents() async {
        isLoading = true
        errorMessage = nil
        do {
            events = try await EventService.getAllEvents()
        } catch {
            print("Error fetching events:", error.localizedDescription)
            errorMessage = "Failed to load events"
        }
        isLoading = false
    }
}
