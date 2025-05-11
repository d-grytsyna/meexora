import Foundation


struct BookingResponse: Decodable {
    let id: UUID
    let eventId: UUID
    let eventTitle: String
    let eventLocation: String
    let eventDateTime: Date
    let expiresAt: Date?
    let totalPrice: Decimal
    let status: String
    var paymentIntent: PaymentIntentResponse?
    let tickets: [BookingTicketResponse]
}
