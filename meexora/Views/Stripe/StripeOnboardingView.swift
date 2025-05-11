import SwiftUI
import SafariServices

struct StripeOnboardingView: View {
    @State private var onboardingURL: URL?
    @State private var showSafari = false
    @State private var status: StripeAccountStatus?
    @State private var error: String?

    var body: some View {
        VStack(spacing: 16) {
            if let status = status {
                if status.chargesEnabled && status.payoutsEnabled {
                    Text("Stripe акаунт активний ✅")
                        .foregroundColor(.green)
                } else {
                    Text("Акаунт ще не активовано")
                        .foregroundColor(.orange)
                }
            }

            Button("Підключити Stripe акаунт") {
                Task {
                    await startOnboarding()
                }
            }
            .buttonStyle(.borderedProminent)

            if let error = error {
                Text(error).foregroundColor(.red)
            }
        }
        .sheet(isPresented: $showSafari) {
            if let url = onboardingURL {
                SafariView(url: url)
            }
        }
        .task {
            await fetchStatus()
        }
    }

    func startOnboarding() async {
        do {
            // Створити акаунт, якщо ще не існує
            _ = try await StripeAccountService.createStripeAccount()
            // Отримати посилання
            let url = try await StripeAccountService.getOnboardingLink()
            onboardingURL = url
            showSafari = true
        } catch {
            self.error = "Помилка онбордингу: \(error.localizedDescription)"
        }
    }

    func fetchStatus() async {
        do {
            let currentStatus = try await StripeAccountService.getStripeAccountStatus()
            self.status = currentStatus
        } catch {
            self.error = "Не вдалося перевірити статус: \(error.localizedDescription)"
        }
    }
}
