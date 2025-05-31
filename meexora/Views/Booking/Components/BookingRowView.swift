import SwiftUI

struct BookingRowView: View {
    let booking: BookingResponse

    var body: some View {
        VStack(alignment: .leading, spacing: StyleGuide.Spacing.small) {
            HStack {
                Text(booking.eventTitle)
                    .font(StyleGuide.Fonts.bodyBold)
                    .foregroundColor(StyleGuide.Colors.primaryText)
                Spacer()
                Text(booking.status.capitalized)
                    .font(StyleGuide.Fonts.small)
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.15))
                    .cornerRadius(StyleGuide.Corners.small)
            }

            Text(booking.eventLocation)
                .font(StyleGuide.Fonts.small)
                .foregroundColor(StyleGuide.Colors.secondaryText)

            if let formattedDate = formattedDate(from: booking.eventDateTime) {
                Text(formattedDate)
                    .font(StyleGuide.Fonts.small)
                    .foregroundColor(StyleGuide.Colors.secondaryText)
            }

            Text("Total: \(booking.totalPrice, format: .currency(code: "EUR"))")
                .font(StyleGuide.Fonts.small)
                .foregroundColor(StyleGuide.Colors.primaryText)
        }
        .padding(StyleGuide.Padding.medium)
        .background(StyleGuide.Colors.primaryBackground)
        .cornerRadius(StyleGuide.Corners.medium)
        .shadow(color: StyleGuide.Shadows.color, radius: StyleGuide.Shadows.radius, x: StyleGuide.Shadows.x, y: StyleGuide.Shadows.y)
        .padding(.horizontal, StyleGuide.Padding.medium)
        .padding(.vertical, StyleGuide.Padding.small)
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
