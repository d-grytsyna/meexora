import Foundation

struct TicketService {

    static func validateTicket(qrCode: String, eventId: UUID) async throws -> TicketValidationResponse {
        let validationRequest = TicketValidationRequest(qrCodeToken: qrCode, eventId: eventId)
        let request = try RequestBuilder.buildRequest(
            path: "/ticket/verify",
            method: "POST",
            body: validationRequest
        )

        return try await APIClient.shared.send(request, responseType: TicketValidationResponse.self)
    }



}
