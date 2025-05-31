import Foundation

struct CreateBookingRequest: Encodable {
    let eventId: UUID
    let tickets: [TicketRequest]
}
