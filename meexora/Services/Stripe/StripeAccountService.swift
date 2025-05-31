import Foundation

struct StripeAccountService {

    static func createStripeAccount() async throws -> String {
        let request = try RequestBuilder.buildRequest(
            path: "/payments/stripe/accounts",
            method: "POST"
        )

        return try await APIClient.shared.send(request, responseType: String.self)
    }

    static func getOnboardingLink() async throws -> URL {
        let request = try RequestBuilder.buildRequest(
            path: "/payments/stripe/accounts/onboarding-link",
            method: "GET"
        )

        let urlString = try await APIClient.shared.send(request, responseType: String.self)

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        return url
    }

    static func getStripeAccountStatus() async throws -> StripeAccountStatus {
        let request = try RequestBuilder.buildRequest(
            path: "/payments/stripe/accounts/status",
            method: "GET"
        )

        return try await APIClient.shared.send(request, responseType: StripeAccountStatus.self)
    }
}
