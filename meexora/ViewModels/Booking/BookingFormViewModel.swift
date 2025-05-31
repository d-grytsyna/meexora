import Foundation
import SwiftUI

@MainActor
class BookingFormViewModel: ObservableObject {
    @Published var ticketNames: [String] = [""]
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var submittedBooking: BookingResponse?

    enum BookingResult {
        case bookingReserved
        case monitoringReserved
        case monitoringCreated
        case conflict
        case error(String)
    }

    func addTicketField() {
        ticketNames.append("")
    }

    func removeTicketField(at index: Int) {
        ticketNames.remove(at: index)
    }

    func handleBookingSubmission(for eventId: UUID, isMonitoring: Bool) async -> BookingResult {
        isLoading = true
        defer { isLoading = false }

        let ticketRequests = ticketNames.map { TicketRequest(userName: $0) }
        let request = CreateBookingRequest(eventId: eventId, tickets: ticketRequests)

        do {
            let response: BookingResponse

            if isMonitoring {
                response = try await BookingService.createWatchingBooking(request)
                self.submittedBooking = response

                if response.status == "RESERVED" {
                    return .monitoringReserved
                } else {
                    return .monitoringCreated
                }
            } else {
                response = try await BookingService.createBooking(request)
                self.submittedBooking = response

                if response.status == "RESERVED" {
                    return .bookingReserved
                } else {
                    return .conflict
                }
            }

        }catch let nsError as NSError {
            if nsError.domain == "APIError", nsError.code == 409 {
                return .conflict
            } else {
                return .error("Booking failed: \(nsError.localizedDescription)")
            }
        }
    }
}
extension Array {
    subscript(safe index: Int) -> Element? {
        get {
            indices.contains(index) ? self[index] : nil
        }
        set {
            if let newValue = newValue, indices.contains(index) {
                self[index] = newValue
            }
        }
    }
}
