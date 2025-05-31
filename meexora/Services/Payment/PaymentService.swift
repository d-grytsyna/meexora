import Foundation

struct PaymentService {
    static func getPaymentIntent(for bookingId: UUID) async throws -> PaymentIntentResponse {
        
        let request = try RequestBuilder.buildRequest(
            path: "/payments/intent",
            method: "GET",
            queryItems: [
                URLQueryItem(name: "bookingId", value: bookingId.uuidString)
            ]
        )

        return try await APIClient.shared.send(request, responseType: PaymentIntentResponse.self)
    }

}
