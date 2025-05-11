import Foundation

class DeepLinkManager: ObservableObject {
    @Published var onboardingCompleted = false
    @Published var onboardingRetry = false

    func handle(url: URL) {
        switch url.absoluteString {
        case "meexora://onboarding/complete":
            onboardingCompleted = true
        case "meeaxora://onboarding/retry":
            onboardingRetry = true
        default:
            break
        }
    }
}
