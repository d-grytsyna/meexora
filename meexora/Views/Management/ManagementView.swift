import SwiftUI
import SafariServices

struct ManagementView: View {
    @StateObject private var viewModel = ManagementViewModel()
    @EnvironmentObject var deepLinkManager: DeepLinkManager

    var body: some View {
        ZStack {
            StyleGuide.Colors.secondaryBackground.ignoresSafeArea()

            NavigationStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .foregroundColor(StyleGuide.Colors.secondaryText)
                } else {
                    VStack(spacing: StyleGuide.Spacing.large) {
                        contentSection
                        statusSection
                    }
                    .padding(StyleGuide.Padding.large)
                    .navigationTitle("My Events")
                    .sheet(item: $viewModel.onboardingLink) { identifiable in
                        SafariView(url: identifiable.url)
                    }
                    .refreshable {
                        await viewModel.fetchAllData()
                    }
                }
            }
        }
        .task {
            await viewModel.fetchAllData()
        }
        .task(id: deepLinkManager.onboardingCompleted) {
            if deepLinkManager.onboardingCompleted {
                await viewModel.fetchStripeStatus()
            }
        }
    }

    @ViewBuilder
    private var contentSection: some View {
        if let error = viewModel.errorMessage, viewModel.events.isEmpty {
            Text(error)
                .foregroundColor(StyleGuide.Colors.errorText)
                .font(StyleGuide.Fonts.body)
        } else if viewModel.events.isEmpty {
            Text("You haven't created any events yet.")
                .foregroundColor(StyleGuide.Colors.secondaryText)
                .font(StyleGuide.Fonts.body)
        } else {
            List(viewModel.events) { event in
                NavigationLink(destination: EventDetailsView(event: event)) {
                    VStack(alignment: .leading, spacing: StyleGuide.Spacing.small) {
                        Text(event.title)
                            .font(StyleGuide.Fonts.bodyBold)
                            .foregroundColor(StyleGuide.Colors.primaryText)
                        Text(event.address)
                            .font(StyleGuide.Fonts.body)
                            .foregroundColor(StyleGuide.Colors.secondaryText)
                        Text("Price: \(event.price)€")
                            .font(StyleGuide.Fonts.small)
                            .foregroundColor(StyleGuide.Colors.secondaryText)
                    }
                    .padding(.vertical, StyleGuide.Padding.small)
                }
                .listRowBackground(StyleGuide.Colors.primaryBackground)
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
        }
    }

    @ViewBuilder
    private var statusSection: some View {
        if let status = viewModel.stripeStatus {
            if status.chargesEnabled && status.payoutsEnabled {
                NavigationLink(destination: CreateEventView()) {
                    Label("Create New Event", systemImage: "plus.circle")
                        .font(StyleGuide.Fonts.button)
                }
                .buttonStyle(.plain)


                Text("Stripe account is active")
                    .font(StyleGuide.Fonts.small)
                    .foregroundColor(.green)
            } else {
                VStack(spacing: StyleGuide.Spacing.medium) {
                    Text("To create events and receive payments, please complete your Stripe account setup.")
                        .font(StyleGuide.Fonts.body)
                        .foregroundColor(StyleGuide.Colors.secondaryText)
                        .multilineTextAlignment(.center)

                    Button("Set Up Stripe Account") {
                        Task {
                            await viewModel.startStripeOnboarding()
                        }
                    }
                    .modifier(StyleGuide.Buttons.primary())
                }
            }
        }
    }
}
