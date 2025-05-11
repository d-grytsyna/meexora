import Foundation

struct EventService {

    static func getMyEvents() async throws -> [EventManagementResponse] {
        let request = try RequestBuilder.buildRequest(
            path: "/event/created",
            method: "GET"
        )

        return try await APIClient.shared.send(request, responseType: [EventManagementResponse].self)
    }

    static func getAllEvents() async throws -> [EventShortResponse] {
        let request = try RequestBuilder.buildRequest(
            path: "/event/public",
            method: "GET"
        )

        return try await APIClient.shared.send(request, responseType: [EventShortResponse].self)
    }


}
