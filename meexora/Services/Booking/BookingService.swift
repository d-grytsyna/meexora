import Foundation
struct BookingService {
    static func createBooking(_ requestBody: CreateBookingRequest) async throws -> BookingResponse {
        let request = try RequestBuilder.buildRequest(
            path: "/bookings",
            method: "POST",
            body: requestBody
        )
        return try await APIClient.shared.send(request, responseType: BookingResponse.self)
    }
    
    static func createWatchingBooking(_ requestBody: CreateBookingRequest) async throws -> BookingResponse {
        let request = try RequestBuilder.buildRequest(
            path: "/bookings/watching",
            method: "POST",
            body: requestBody
        )
        return try await APIClient.shared.send(request, responseType: BookingResponse.self)
    }
    
    static func retryPaymentIntent(bookingId: UUID) async throws -> BookingResponse{
        let request = try RequestBuilder.buildRequest(
            path: "/bookings/" + bookingId.uuidString + "/payment-intent",
            method: "POST"
        )
        return try await APIClient.shared.send(request, responseType: BookingResponse.self)
    }
    
    static func checkAvailability(eventId: UUID) async throws -> Bool {
        let request = try RequestBuilder.buildRequest(
            path: "/bookings/availability",
            method: "GET",
            queryItems: [
                URLQueryItem(name: "eventId", value: eventId.uuidString)
            ]
        )
        return try await APIClient.shared.send(request, responseType: Bool.self)
    }

}
