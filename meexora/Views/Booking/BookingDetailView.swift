import SwiftUI

struct BookingDetailView: View {
    let booking: BookingResponse

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: StyleGuide.Spacing.medium) {
                headerSection
                locationSection
                dateSection
                statusSection
                priceSection
                ticketsSection
            }
            .padding(StyleGuide.Padding.large)
        }
        .background(StyleGuide.Colors.secondaryBackground.ignoresSafeArea())
        .navigationTitle("Booking Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerSection: some View {
        Text(booking.eventTitle)
            .font(StyleGuide.Fonts.title)
            .foregroundColor(StyleGuide.Colors.primaryText)
    }

    private var locationSection: some View {
        HStack {
            Image(systemName: "mappin.and.ellipse")
                .foregroundColor(StyleGuide.Colors.accentPurple)
            Text(booking.eventLocation)
                .font(StyleGuide.Fonts.body)
                .foregroundColor(StyleGuide.Colors.secondaryText)
        }
    }

    private var dateSection: some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(StyleGuide.Colors.accentBlue)
            Text(formattedDate(from: booking.eventDateTime) ?? "")
                .font(StyleGuide.Fonts.body)
                .foregroundColor(StyleGuide.Colors.secondaryText)
        }
    }

    private var statusSection: some View {
        HStack {
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
    }

    private var priceSection: some View {
        HStack {
            Text("Total price:")
                .font(StyleGuide.Fonts.bodyBold)
            Text(booking.totalPrice, format: .currency(code: "EUR"))
                .font(StyleGuide.Fonts.body)
                .foregroundColor(StyleGuide.Colors.primaryText)
        }
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
                        }
                    }

                }
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

    private func formattedDate(from date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
