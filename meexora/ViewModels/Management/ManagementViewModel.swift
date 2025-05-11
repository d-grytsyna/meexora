import Foundation

struct IdentifiableURL: Identifiable {
    var id: URL { url }
    let url: URL
}

@MainActor
class ManagementViewModel: ObservableObject {
    @Published var events: [EventManagementResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var onboardingLink: IdentifiableURL?
    @Published var stripeStatus: StripeAccountStatus?

    func fetchMyEvents() async {
        isLoading = true
        defer { isLoading = false }

        do {
            events = try await EventService.getMyEvents()
        } catch {
            errorMessage = "Failed to load events: \(error.localizedDescription)"
        }
    }

    func startStripeOnboarding() async {
        do {
            _ = try await StripeAccountService.createStripeAccount()
            let link = try await StripeAccountService.getOnboardingLink()
            onboardingLink = IdentifiableURL(url: link)
        } catch {
            errorMessage = "Stripe onboarding error: \(error.localizedDescription)"
        }
    }

    func fetchStripeStatus() async {
        do {
            stripeStatus = try await StripeAccountService.getStripeAccountStatus()
        } catch {
            errorMessage = "Stripe status error: \(error.localizedDescription)"
        }
    }
}
