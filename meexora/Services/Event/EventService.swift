import Foundation

struct EventService {

    static func getMyEvents() async throws -> [EventManagementResponse] {
        let request = try RequestBuilder.buildRequest(
            path: "/event/created",
            method: "GET"
        )

        return try await APIClient.shared.send(request, responseType: [EventManagementResponse].self)
    }


    static func getPaginatedEvents(city: String, category: EventCategory?, page: Int, size: Int = 10) async throws -> PaginatedResponse<EventShortResponse> {
            var queryItems: [URLQueryItem] = [
                URLQueryItem(name: "city", value: city),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "size", value: "\(size)")
            ]

            if let category = category {
                queryItems.append(URLQueryItem(name: "category", value: category.rawValue))
            }

            let request = try RequestBuilder.buildRequest(
                path: "/event/public",
                method: "GET",
                queryItems: queryItems
            )

            return try await APIClient.shared.send(request, responseType: PaginatedResponse<EventShortResponse>.self)
    }
    static func getNearbyEvents(
        latitude: Double,
        longitude: Double,
        category: EventCategory?,
        page: Int,
        size: Int = 10
    ) async throws -> PaginatedResponse<EventShortResponse> {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lng", value: "\(longitude)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "\(size)")
        ]

        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: category.rawValue))
        }

        let request = try RequestBuilder.buildRequest(
            path: "/event/nearby",
            method: "GET",
            queryItems: queryItems
        )

        return try await APIClient.shared.send(request, responseType: PaginatedResponse<EventShortResponse>.self)
    }


    static func createEvent(newEvent: CreateEventRequest) async throws  -> EventResponse {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        let request = try RequestBuilder.buildRequest(
            path: "/event/create",
            method: "POST",
            body: newEvent,
            encoder: encoder
        )

        
        return try await APIClient.shared.send(request, responseType: EventResponse.self)
    }


}
