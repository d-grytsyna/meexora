import SwiftUI
import SafariServices

struct ManagementView: View {
    @StateObject private var viewModel = ManagementViewModel()
    @EnvironmentObject var deepLinkManager: DeepLinkManager

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red)
                } else if viewModel.events.isEmpty {
                    Text("You haven't created any events yet.")
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.events) { event in
                        NavigationLink(destination: EventDetailsView(event: event)) {
                            VStack(alignment: .leading) {
                                Text(event.title).font(.headline)
                                Text(event.address).font(.subheadline)
                                Text("Price: \(event.price)₴").font(.caption)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Button("Set Up Stripe Account") {
                    Task {
                        await viewModel.startStripeOnboarding()
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)

                if let status = viewModel.stripeStatus {
                    Text(status.chargesEnabled && status.payoutsEnabled
                         ? "Stripe account is active ✅"
                         : "Stripe account is incomplete ⚠️"
                    )
                    .font(.subheadline)
                    .foregroundColor(status.chargesEnabled ? .green : .orange)
                }
            }
            .navigationTitle("My Events")
            .task {
                await viewModel.fetchMyEvents()
                await viewModel.fetchStripeStatus()
            }
            .sheet(item: $viewModel.onboardingLink) { identifiable in
                SafariView(url: identifiable.url)
            }
            .task(id: deepLinkManager.onboardingCompleted) {
                if deepLinkManager.onboardingCompleted {
                    await viewModel.fetchStripeStatus()
                }
            }
        }
    }
}
