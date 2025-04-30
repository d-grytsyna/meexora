import Foundation

struct AuthService {
    static func login(email: String, password: String) async throws -> AuthResponse {
        let request = try RequestBuilder.buildRequest(
            path: "/auth/login",
            method: "POST",
            body: AuthRequest(email: email, password: password)
        )
        let (data, response) = try await URLSession.shared.data(for: request)
        if let error = NetworkErrorHandler.handle(response: response, data: data) {throw error}
        let apiResponse = try JSONDecoder().decode(ApiResponse<AuthResponse>.self, from: data)
        return apiResponse.data
    }
    
    static func requestRegistration(email: String) async throws {
            let request = try RequestBuilder.buildRequest(
                path: "/auth/registration/request",
                method: "POST",
                body: AccountModificationRequest(email: email)
            )
            let (data, response) = try await URLSession.shared.data(for: request)
            if let error = NetworkErrorHandler.handle(response: response, data: data) { throw error }
    }
    
    static func confirmRegistration(email: String, password: String, role: String, code: String) async throws -> AuthResponse {
            let request = try RequestBuilder.buildRequest(
                path: "/auth/registration/confirm",
                method: "POST",
                body: ConfirmRegistrationRequest(email: email, password: password, role: role, code: code)
            )
            let (data, response) = try await URLSession.shared.data(for: request)
            if let error = NetworkErrorHandler.handle(response: response, data: data) { throw error }
            let apiResponse = try JSONDecoder().decode(ApiResponse<AuthResponse>.self, from: data)
            return apiResponse.data
    }
    
    static func requestPasswordReset(email: String) async throws{
        let request = try RequestBuilder.buildRequest(
            path: "/auth/password-reset/request",
            method: "POST",
            body: AccountModificationRequest(email: email)
        )
        let (data, response) = try await URLSession.shared.data(for: request)
        if let error = NetworkErrorHandler.handle(response: response, data: data) { throw error }
    }
    
    static func confirmPasswordReset(email:String, newPassword: String, code: String) async throws  -> AuthResponse{
        let request = try RequestBuilder.buildRequest(
            path: "/auth/password-reset/confirm",
            method: "POST",
            body: ConfirmPasswordResetRequest(email: email, newPassword: newPassword, code: code)
        )
        let (data, response) = try await URLSession.shared.data(for: request)
        if let error = NetworkErrorHandler.handle(response: response, data: data) { throw error }
        let apiResponse = try JSONDecoder().decode(ApiResponse<AuthResponse>.self, from: data)
        return apiResponse.data
    }


}
