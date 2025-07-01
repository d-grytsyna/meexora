import SwiftUI
struct BookingDetailView: View {
    let booking: BookingResponse
    @StateObject private var viewModel = BookingDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {

        NavigationStack {
            ZStack {
                StyleGuide.Colors.primaryBackground
                    .ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: StyleGuide.Spacing.extraLarge) {
                        infoCard
                        ticketsSection

                        if booking.status.uppercased() == "WATCHING" {
                            VStack(spacing: StyleGuide.Spacing.small) {
                                Button(action: {
                                    Task {
                                        await viewModel.cancelMonitoring(bookingId: booking.id)
                                    }
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "eye.slash")
                                        Text("Cancel Monitoring")
                                    }
                                    .font(StyleGuide.Fonts.bodyBold)
                                    .foregroundColor(StyleGuide.Colors.errorText)
                                    .padding()
                                    .background(StyleGuide.Colors.secondaryBackground)
                                    .cornerRadius(StyleGuide.Corners.medium)
                                }
                                .accessibilityLabel("Cancel Monitoring")

                                if let errorMessage = viewModel.errorMessage {
                                    Text(errorMessage)
                                        .font(StyleGuide.Fonts.small)
                                        .foregroundColor(StyleGuide.Colors.errorText)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .standardPagePadding()
            }
            .navigationTitle("Booking Details")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Monitoring cancelled", isPresented: $viewModel.showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("You will no longer receive notifications for this event.")
            }
        }

    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: StyleGuide.Spacing.medium) {
            Text(booking.eventTitle)
                .font(StyleGuide.Fonts.title)
                .foregroundColor(StyleGuide.Colors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: StyleGuide.Spacing.small) {
                Image(systemName: "calendar")
                    .foregroundColor(StyleGuide.Colors.accentPurple)
                Text(formattedDate(from: booking.eventDateTime))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: StyleGuide.Spacing.small) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(StyleGuide.Colors.accentPurple)
                Text(booking.eventLocation)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: StyleGuide.Spacing.small) {
                Text("Status:")
                    .font(StyleGuide.Fonts.bodyBold)
                Text(booking.status.capitalized)
                    .foregroundColor(statusColor)
                    .font(StyleGuide.Fonts.body)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.15))
                    .cornerRadius(StyleGuide.Corners.small)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: StyleGuide.Spacing.small) {
                Image(systemName: "ticket")
                    .foregroundColor(StyleGuide.Colors.accentBlue)
                Text("Total: \(booking.totalPrice.formatted(.currency(code: "EUR")))")
                    .font(StyleGuide.Fonts.bodyBold)
                    .foregroundColor(StyleGuide.Colors.accentBlue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(StyleGuide.Colors.secondaryBackground)
        .cornerRadius(StyleGuide.Corners.medium)
        .frame(maxWidth: .infinity)
    }


    private var ticketsSection: some View {
        Group {
            if !booking.tickets.isEmpty {
                VStack(alignment: .leading, spacing: StyleGuide.Spacing.small) {
                    Text("Tickets")
                        .font(StyleGuide.Fonts.bodyBold)
                        .foregroundColor(StyleGuide.Colors.primaryText)

                    ForEach(booking.tickets, id: \.id) { ticket in
                        HStack {
                            Text("• \(ticket.userName)")
                            Spacer()
                            Text(ticket.status.capitalized)
                                .font(StyleGuide.Fonts.small)
                                .foregroundColor(StyleGuide.Colors.secondaryText)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .background(StyleGuide.Colors.secondaryBackground)
                .cornerRadius(StyleGuide.Corners.medium)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var statusColor: Color {
        switch booking.status {
        case "PAID": return StyleGuide.Colors.accentBlue
        case "RESERVED": return StyleGuide.Colors.accentYellow
        case "REFUND", "REFUND_FAILED": return StyleGuide.Colors.errorText
        case "WATCHING": return StyleGuide.Colors.accentPurple
        default: return StyleGuide.Colors.secondaryText
        }
    }

    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
