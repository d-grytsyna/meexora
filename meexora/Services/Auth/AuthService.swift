import Foundation

struct AuthService {

    static func login(email: String, password: String) async throws -> AuthResponse {
        let request = try RequestBuilder.buildRequest(
            path: "/auth/login",
            method: "POST",
            body: AuthRequest(email: email, password: password)
        )

        return try await APIClient.shared.send(request, responseType: AuthResponse.self)
    }
    static func logout() async throws{
        let request = try RequestBuilder.buildRequest(
            path: "/auth/logout",
            method: "POST",
            body: nil
        )

        try await APIClient.shared.sendVoid(request)
    }

    static func requestRegistration(email: String) async throws {
        let request = try RequestBuilder.buildRequest(
            path: "/auth/registration/request",
            method: "POST",
            body: AccountModificationRequest(email: email)
        )

        try await APIClient.shared.sendVoid(request)
    }

    static func confirmRegistration(email: String, password: String, role: String, code: String) async throws -> AuthResponse {
        let request = try RequestBuilder.buildRequest(
            path: "/auth/registration/confirm",
            method: "POST",
            body: ConfirmRegistrationRequest(email: email, password: password, role: role, code: code)
        )

        return try await APIClient.shared.send(request, responseType: AuthResponse.self)
    }

    static func requestPasswordReset(email: String) async throws {
        let request = try RequestBuilder.buildRequest(
            path: "/auth/password-reset/request",
            method: "POST",
            body: AccountModificationRequest(email: email)
        )

        try await APIClient.shared.sendVoid(request)
    }

    static func confirmPasswordReset(email: String, newPassword: String, code: String) async throws -> AuthResponse {
        let request = try RequestBuilder.buildRequest(
            path: "/auth/password-reset/confirm",
            method: "POST",
            body: ConfirmPasswordResetRequest(email: email, newPassword: newPassword, code: code)
        )

        return try await APIClient.shared.send(request, responseType: AuthResponse.self)
    }

    static func refreshToken() async throws -> AuthResponse {
        guard let refreshToken = TokenStorage.getRefreshToken() else {
            throw URLError(.userAuthenticationRequired)
        }

        let request = try RequestBuilder.buildRequest(
            path: "/auth/refresh",
            method: "POST",
            body: ["refreshToken": refreshToken]
        )

        return try await APIClient.shared.send(request, responseType: AuthResponse.self)
    }
}

