import Foundation

@MainActor
class BookingDetailViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showSuccessAlert = false

    func cancelMonitoring(bookingId: UUID) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await BookingService.cancelMonitoring(bookingId: bookingId)
            if result {
                showSuccessAlert = true
            } else {
                errorMessage = "Failed to cancel monitoring."
            }
        } catch {
            print("Booking canceling error: \(error)")
            errorMessage = error.localizedDescription
        }
    }
}
