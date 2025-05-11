import Foundation

struct PaymentService {
    static func getPaymentIntent(for bookingId: UUID) async throws -> PaymentIntentResponse {
        let request = try RequestBuilder.buildRequest(
            path: "/payment/booking/\(bookingId)",
            method: "GET"
        )

        return try await APIClient.shared.send(request, responseType: PaymentIntentResponse.self)
    }
}
