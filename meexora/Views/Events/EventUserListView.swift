import SwiftUI

struct EventUserListView: View {
    @StateObject private var viewModel = EventUserListViewModel()
    @State private var selectedTab: EventSearchMode = .city

    var body: some View {
        NavigationStack {
            ZStack {
                StyleGuide.Gradients.background
                    .ignoresSafeArea()

                if viewModel.isInitialized {
                    VStack(spacing: StyleGuide.Spacing.medium) {
                        if viewModel.isLocationAvailable {
                            Picker("Mode", selection: $selectedTab) {
                                ForEach(EventSearchMode.allCases, id: \.self) { mode in
                                    Text(mode.displayName).tag(mode)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)
                        }

                        categoryPicker
                        selectedCategoryHeader
                        eventContent
                            .frame(maxHeight: .infinity)
                    }
                    .frame(maxHeight: .infinity)
                    .standardPagePadding()
                } else {
                    ProgressView("Checking location...")
                }
            }
            .navigationTitle("Available Events")
        }
        .task {
            await viewModel.checkLocationAvailability()
            if viewModel.isInitialized {
                await viewModel.resetAndFetch()
            }
        }
        .onChange(of: viewModel.selectedCategory) {
            Task {
                await viewModel.resetAndFetch()
            }
        }
        .onChange(of: selectedTab) {
            Task {
                await viewModel.updateMode(to: selectedTab)
            }
        }
    }


    private var categoryPicker: some View {
        CustomPicker<EventCategory?>(
            title: "Category",
            options: [nil] + EventCategory.allCases,
            selection: $viewModel.selectedCategory,
            labelProvider: { category in
                category?.displayName ?? "All Categories"
            },
            iconNameProvider: { category in
                category?.iconNameSmall ?? ""
            }
        )
        .padding(.horizontal)
    }

    private var selectedCategoryHeader: some View {
        Group {
            if let category = viewModel.selectedCategory {
                HStack(alignment: .center, spacing: StyleGuide.Spacing.medium) {
                    Image(category.iconNameLarge)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)

                    Text("\(category.displayName) events")
                        .font(StyleGuide.Fonts.title)
                        .foregroundColor(StyleGuide.Colors.primaryText)

                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(StyleGuide.Colors.secondaryBackground)
                .cornerRadius(StyleGuide.Corners.medium)
                .shadow(color: StyleGuide.Shadows.color, radius: StyleGuide.Shadows.radius, x: StyleGuide.Shadows.x, y: StyleGuide.Shadows.y)
                .padding(.horizontal)
            }
        }
    }

    private var eventContent: some View {
        Group {
            if viewModel.isLoading && viewModel.events.isEmpty {
                VStack {
                    Spacer()
                    ProgressView("Loading events...")
                        .progressViewStyle(CircularProgressViewStyle(tint: StyleGuide.Colors.primaryText))
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(StyleGuide.Colors.errorText)
                    .padding()
            } else if viewModel.events.isEmpty {
                Text("No events available")
                    .foregroundColor(StyleGuide.Colors.secondaryText)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: StyleGuide.Spacing.medium) {
                        ForEach(viewModel.events) { event in
                            EventCardView(event: event, showIcon: viewModel.selectedCategory == nil)
                                .frame(maxWidth: .infinity)
                                .onAppear {
                                    Task {
                                        await viewModel.fetchNextPageIfNeeded(currentItem: event)
                                    }
                                }
                        }

                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

enum EventSearchMode: String, CaseIterable, Identifiable {
    case city
    case nearby

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .city: return "In City"
        case .nearby: return "Nearby"
        }
    }
}

struct EventCardView: View {
    let event: EventShortResponse
    let showIcon: Bool

    var body: some View {
        NavigationLink(destination: EventUserInfoView(event: event)) {
            HStack(alignment: .center, spacing: StyleGuide.Spacing.medium) {
                if showIcon {
                    ZStack {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 100, height: 100)
                            .cornerRadius(StyleGuide.Corners.small)

                        Image(event.category.iconNameLarge)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                    .frame(width: 100, height: 100, alignment: .center)
                }
                VStack(alignment: .leading, spacing: StyleGuide.Spacing.small) {
                    Text(event.title)
                        .font(StyleGuide.Fonts.title)
                        .foregroundColor(StyleGuide.Colors.primaryText)
                        .multilineTextAlignment(.leading)

                    let shortDescription = event.description.count > 70
                        ? event.description.prefix(67) + "..."
                        : event.description

                    Text(shortDescription)
                        .font(StyleGuide.Fonts.body)
                        .foregroundColor(StyleGuide.Colors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)


                    Text(event.address)
                        .font(StyleGuide.Fonts.small)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)

                    Text(event.date.formatted(date: .abbreviated, time: .shortened))
                        .font(StyleGuide.Fonts.small)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(StyleGuide.Colors.secondaryBackground)
            .cornerRadius(StyleGuide.Corners.medium)
            .shadow(color: StyleGuide.Shadows.color, radius: StyleGuide.Shadows.radius, x: StyleGuide.Shadows.x, y: StyleGuide.Shadows.y)
        }
    }
}
