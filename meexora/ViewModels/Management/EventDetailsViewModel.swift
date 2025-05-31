import Foundation


@MainActor
final class EventDetailsViewModel: ObservableObject {
    @Published var validationMessage: String?
    @Published var isLoading = false

    func validate(scannedCode: String, eventId: UUID) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await TicketService.validateTicket(qrCode: scannedCode, eventId: eventId)
            validationMessage = "Valid ticket for \(response.userName)"
        } catch {
            validationMessage = "Invalid ticket: \(error.localizedDescription)"
        }
    }
}
