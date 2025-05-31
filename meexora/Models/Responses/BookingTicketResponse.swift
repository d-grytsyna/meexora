import Foundation

struct BookingTicketResponse: Codable, Identifiable {
    let id: UUID
    var userName: String
    var status: String
}
