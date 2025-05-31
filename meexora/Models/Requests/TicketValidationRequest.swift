import Foundation

struct TicketValidationRequest: Encodable {
    let qrCodeToken: String
    let eventId: UUID
}
