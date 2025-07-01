import SwiftUI
import SafariServices

import SwiftUI

struct ManagementView: View {
    @StateObject private var viewModel = ManagementViewModel()
    @EnvironmentObject var deepLinkManager: DeepLinkManager
    @State private var selectedTab: EventTab = .upcoming

    var body: some View {
        ZStack {
            StyleGuide.Colors.secondaryBackground.ignoresSafeArea()

            NavigationStack {
                content
                    .navigationTitle("My Events")
                    .sheet(item: $viewModel.onboardingLink) { identifiable in
                        SafariView(url: identifiable.url)
                    }
                    .refreshable {
                        await viewModel.fetchAllData()
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
    private var content: some View {
        if viewModel.isLoading {
            ProgressView("Loading...")
                .foregroundColor(StyleGuide.Colors.secondaryText)
        } else {
            VStack(spacing: StyleGuide.Spacing.large) {
                tabPicker
                eventList
                statusSection
            }
            .padding(StyleGuide.Padding.large)
        }
    }

    private var filteredEvents: [EventManagementResponse] {
        switch selectedTab {
        case .upcoming:
            return viewModel.events.filter { $0.date > Date() }
        case .history:
            return viewModel.events.filter { $0.date <= Date() }
        }
    }

    private var tabPicker: some View {
        Picker("Event Tab", selection: $selectedTab) {
            Text("Upcoming").tag(EventTab.upcoming)
            Text("History").tag(EventTab.history)
        }
        .pickerStyle(.segmented)
    }

    private var eventList: some View {
        ScrollView {
            LazyVStack(spacing: StyleGuide.Spacing.medium) {
                if filteredEvents.isEmpty {
                    Text("No events found.")
                        .foregroundColor(StyleGuide.Colors.secondaryText)
                        .font(StyleGuide.Fonts.body)
                        .padding(.top)
                } else {
                    ForEach(filteredEvents) { event in
                        NavigationLink(destination: EventDetailsView(event: event)) {
                            ManagementEventCardView(event: event)
                        }
                    }
                }
            }
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

    enum EventTab: String, CaseIterable, Hashable {
        case upcoming
        case history
    }
}

struct ManagementEventCardView: View {
    let event: EventManagementResponse

    var body: some View {
        HStack(spacing: StyleGuide.Spacing.medium) {
            Image(event.category.iconNameLarge)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(StyleGuide.Colors.accentPurple)

            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(StyleGuide.Fonts.bodyBold)
                    .foregroundColor(StyleGuide.Colors.primaryText)

                Text(event.address)
                    .font(StyleGuide.Fonts.small)
                    .foregroundColor(StyleGuide.Colors.secondaryText)

                Text(event.date.formatted(date: .abbreviated, time: .shortened))
                    .font(StyleGuide.Fonts.small)
                    .foregroundColor(StyleGuide.Colors.secondaryText)
            } .frame(maxWidth: .infinity, alignment: .leading)


        
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(StyleGuide.Colors.primaryBackground)
        .cornerRadius(StyleGuide.Corners.medium)
        .shadow(color: StyleGuide.Shadows.color.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
