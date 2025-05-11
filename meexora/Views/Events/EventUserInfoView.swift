import SwiftUI

struct EventUserInfoView: View {
    let event: EventShortResponse
    @StateObject private var viewModel = EventUserInfoViewModel()
    @State private var isBookingActive = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: StyleGuide.Spacing.large) {

                    VStack(alignment: .leading, spacing: StyleGuide.Spacing.small) {
                        Text(event.title)
                            .font(StyleGuide.Fonts.title)
                            .foregroundColor(StyleGuide.Colors.primaryText)

                        Text(event.description)
                            .font(StyleGuide.Fonts.body)
                            .foregroundColor(StyleGuide.Colors.secondaryText)

                        HStack(spacing: StyleGuide.Spacing.small) {
                            Image(systemName: "calendar")
                            Text(event.date.formatted(date: .long, time: .shortened))
                        }
                        .font(StyleGuide.Fonts.small)
                        .foregroundColor(StyleGuide.Colors.secondaryText)

                        HStack(spacing: StyleGuide.Spacing.small) {
                            Image(systemName: "mappin.and.ellipse")
                            Text(event.address)
                        }
                        .font(StyleGuide.Fonts.small)
                        .foregroundColor(StyleGuide.Colors.secondaryText)
                    }
                    .padding(StyleGuide.Padding.medium)
                    .frame(maxWidth: .infinity)
                    .background(StyleGuide.Colors.secondaryBackground)
                    .cornerRadius(StyleGuide.Corners.medium)

                    if viewModel.isLoading {
                        ProgressView()
                    } else if let isAvailable = viewModel.isAvailable {
                        Button(isAvailable ? "Book Now" : "Monitor Tickets") {
                            isBookingActive = true
                        }
                        .modifier(StyleGuide.Buttons.primary())
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .font(StyleGuide.Fonts.small)
                            .foregroundColor(StyleGuide.Colors.errorText)
                    }

                    NavigationLink(
                        destination: BookingFormView(event: event, isMonitoringMode: !(viewModel.isAvailable ?? false)),
                        isActive: $isBookingActive
                    ) {
                        EmptyView()
                    }
                }
                .padding(StyleGuide.Padding.large)
            }
            .background(StyleGuide.Colors.primaryBackground.ignoresSafeArea())
            .navigationTitle("Event Info")
            .task {
                await viewModel.checkAvailability(for: event.id)
            }
        }
    }
}
