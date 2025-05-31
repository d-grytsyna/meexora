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

    func fetchAllData() async {
        isLoading = true
        defer { isLoading = false }

        async let eventsTask: () = fetchMyEvents()
        async let stripeTask: () = fetchStripeStatus()
        _ = await (eventsTask, stripeTask)
    }

    func fetchMyEvents() async {
        do {
            events = try await EventService.getMyEvents()
            errorMessage = nil
        } catch {
            errorMessage = "Failed to load events: \(error.localizedDescription)"
            events = []
        }
    }

    func fetchStripeStatus() async {
        do {
            stripeStatus = try await StripeAccountService.getStripeAccountStatus()
        } catch {
            stripeStatus = StripeAccountStatus(chargesEnabled: false, payoutsEnabled: false, detailsSubmitted: false)
        }
    }

    func startStripeOnboarding() async {
        do {
            _ = try await StripeAccountService.createStripeAccount()
            let link = try await StripeAccountService.getOnboardingLink()
            onboardingLink = IdentifiableURL(url: link)
            errorMessage = nil
        } catch {
            errorMessage = nil
        }
    }
}
