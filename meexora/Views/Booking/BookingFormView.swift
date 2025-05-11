import SwiftUI

struct BookingFormView: View {
    let event: EventShortResponse
    let isMonitoringMode: Bool

    @StateObject private var viewModel = BookingFormViewModel()
    @State private var navigateToNextStep = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var promptMonitoring = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: StyleGuide.Spacing.large) {
                    eventInfoSection
                    ticketInputSection
                    errorSection
                    submitButton
                }
                .padding()
            }
            .background(StyleGuide.Colors.primaryBackground.ignoresSafeArea())
            .navigationTitle(isMonitoringMode ? "Monitor Tickets" : "Book Tickets")
            .navigationDestination(isPresented: $navigateToNextStep) {
                if let booking = viewModel.submittedBooking {
                    BookingPaymentView(booking: booking)
                }
            }
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            }
            .alert("Tickets are no longer available. Do you want to enable monitoring?", isPresented: $promptMonitoring) {
                Button("Yes") {
                    Task {
                        let result = await viewModel.handleBookingSubmission(for: event.id, isMonitoring: true)
                        switch result {
                        case .monitoringCreated:
                            alertMessage = "Monitoring has been created."
                        case .monitoringReserved:
                            alertMessage = "Tickets became available and your booking has been created."
                        default: break
                        }
                        showAlert = true
                    }
                }
                Button("No", role: .cancel) {}
            }
        }
    }

    private var eventInfoSection: some View {
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
        .padding(.horizontal)
    }

    private var ticketInputSection: some View {
        VStack(spacing: StyleGuide.Spacing.medium) {
            Text("Ticket Holders")
                .font(StyleGuide.Fonts.bodyBold)
                .foregroundColor(StyleGuide.Colors.primaryText)

            ForEach(Array(viewModel.ticketNames.indices), id: \.self) { index in
                HStack {
                    CustomTextField(
                        placeholder: "Full name",
                        text: Binding(
                            get: { viewModel.ticketNames[safe: index] ?? "" },
                            set: { viewModel.ticketNames[safe: index] = $0 }
                        ),
                        isSecure: false
                    )

                    if viewModel.ticketNames.count > 1 {
                        Button(action: {
                            viewModel.removeTicketField(at: index)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }


            Button(action: viewModel.addTicketField) {
                Label("Add Ticket", systemImage: "plus.circle")
                    .font(StyleGuide.Fonts.button)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
    }

    private var errorSection: some View {
        Group {
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(StyleGuide.Fonts.small)
                    .padding(.horizontal)
                    .foregroundColor(StyleGuide.Colors.errorText)
            }
        }
    }

    private var submitButton: some View {
        Button(action: {
            Task {
                let result = await viewModel.handleBookingSubmission(for: event.id, isMonitoring: isMonitoringMode)

                switch result {
                case .bookingReserved:
                    navigateToNextStep = true
                case .monitoringReserved:
                    alertMessage = "Tickets became available and your booking has been created."
                    showAlert = true
                case .monitoringCreated:
                    alertMessage = "Tickets are not available at the moment. Monitoring has been created."
                    showAlert = true
                case .conflict:
                    promptMonitoring = true
                case .error(let message):
                    alertMessage = message
                    showAlert = true
                }
            }
        }) {
            if viewModel.isLoading {
                ProgressView()
                    .modifier(StyleGuide.ProgressButtons.primary())
            } else {
                Text(isMonitoringMode ? "Monitor Tickets" : "Submit Booking")
                    .modifier(StyleGuide.Buttons.primary())
            }
        }
        .disabled(viewModel.isLoading)
        .padding(.horizontal)
    }
}

#Preview {
    BookingFormView(
        event: EventShortResponse(
            id: UUID(),
            creatorId: UUID(),
            title: "Test Event",
            description: "This is a preview of a sample event used for testing the booking form view.",
            date: Date(),
            latitude: 50.4501,
            longitude: 30.5234,
            address: "Maidan Nezalezhnosti, Kyiv, Ukraine"
        ), isMonitoringMode: true
    )
}
