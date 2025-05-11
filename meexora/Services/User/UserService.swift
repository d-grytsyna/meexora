import Foundation

struct UserService {

    static func getProfile() async throws -> UserProfileDto {
        let request = try RequestBuilder.buildRequest(
            path: "/user/profile",
            method: "GET"
        )

        return try await APIClient.shared.send(request, responseType: UserProfileDto.self)
    }

    static func saveProfile(_ profile: UserProfileDto) async throws {
        let request = try RequestBuilder.buildRequest(
            path: "/user/profile",
            method: "POST",
            body: profile
        )

        try await APIClient.shared.sendVoid(request)
    }
}
