import SwiftUI
import StripePaymentSheet
import Stripe

struct BookingPaymentView: View {
    @StateObject var viewModel: BookingPaymentViewModel
    @State private var paymentSheet: PaymentSheet?

    init(booking: BookingResponse) {
        _viewModel = StateObject(wrappedValue: BookingPaymentViewModel(booking: booking))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: StyleGuide.Spacing.large) {

                // MARK: Timer
                if !viewModel.paymentCompleted {
                    if !viewModel.bookingExpired {
                        Text("Time remaining: \(viewModel.formattedTime)")
                            .font(StyleGuide.Fonts.body)
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                }

                if let booking = viewModel.booking {
                    eventInfoSection(booking: booking)
                    ticketSection(booking: booking)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(StyleGuide.Fonts.small)
                        .foregroundColor(StyleGuide.Colors.errorText)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                }

                if viewModel.paymentCompleted {
                    VStack(spacing: StyleGuide.Spacing.medium) {
                        Text("Payment successful!")
                            .font(StyleGuide.Fonts.bodyBold)
                            .foregroundColor(.green)

                        Text("If your booking was still valid, your tickets will be sent to your email shortly. Otherwise, your payment will be automatically refunded.")
                            .font(StyleGuide.Fonts.body)
                            .foregroundColor(StyleGuide.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)

                } else if !viewModel.bookingExpired {
                    if viewModel.paymentCreated, let clientSecret = viewModel.clientSecret {
                        Button("Pay Now") {
                            presentPaymentSheet(clientSecret: clientSecret)
                        }
                        .modifier(StyleGuide.Buttons.accent())
                    } else {
                        VStack(alignment: .leading, spacing: StyleGuide.Spacing.medium) {
                            Text("Payment has not been initialized.")
                                .font(StyleGuide.Fonts.body)
                                .foregroundColor(StyleGuide.Colors.secondaryText)

                            Text("Something went wrong while preparing your payment. Please try again. If the problem persists, contact support.")
                                .font(StyleGuide.Fonts.small)
                                .foregroundColor(StyleGuide.Colors.secondaryText)

                            Button {
                                Task {
                                    await viewModel.retryPaymentIntent()
                                }
                            } label: {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .modifier(StyleGuide.ProgressButtons.primary())
                                } else {
                                    Text("Try Again")
                                        .modifier(StyleGuide.Buttons.primary())
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    }

                } else {
                    Text("Your booking has expired")
                        .font(StyleGuide.Fonts.body)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                }

            }
            .padding(StyleGuide.Padding.large)
        }
        .background(StyleGuide.Colors.primaryBackground.ignoresSafeArea())
        .navigationTitle("Complete Payment")
    }

    private func presentPaymentSheet(clientSecret: String) {
        var config = PaymentSheet.Configuration()
        config.merchantDisplayName = "Meexora"
        paymentSheet = PaymentSheet(paymentIntentClientSecret: clientSecret, configuration: config)

        if let topVC = UIApplication.shared.topMostViewController() {
            paymentSheet?.present(from: topVC) { result in
                switch result {
                case .completed:
                    viewModel.paymentCompleted = true
                    viewModel.errorMessage = nil
                case .canceled: break
                case .failed(let error):
                    viewModel.errorMessage = "Payment failed: \(error.localizedDescription)"
                }
            }
        } else {
            viewModel.errorMessage = "Unable to find top view controller"
        }
    }

    private func eventInfoSection(booking: BookingResponse) -> some View {
        VStack(alignment: .leading, spacing: StyleGuide.Spacing.small) {
            Text(booking.eventTitle)
                .font(StyleGuide.Fonts.title)
                .foregroundColor(StyleGuide.Colors.primaryText)

            HStack(spacing: StyleGuide.Spacing.small) {
                Image(systemName: "calendar")
                    .foregroundColor(StyleGuide.Colors.accentPurple)
                Text(booking.eventDateTime.formatted(date: .long, time: .shortened))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: StyleGuide.Spacing.small) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(StyleGuide.Colors.accentPurple)
                Text(booking.eventLocation)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(StyleGuide.Colors.secondaryBackground)
        .cornerRadius(StyleGuide.Corners.medium)
    }

    private func ticketSection(booking: BookingResponse) -> some View {
        VStack(alignment: .leading, spacing: StyleGuide.Spacing.medium) {
            Text("Tickets")
                .font(StyleGuide.Fonts.bodyBold)
                .foregroundColor(StyleGuide.Colors.primaryText)

            ForEach(booking.tickets) { ticket in
                HStack {
                    Text(ticket.userName)
                        .font(StyleGuide.Fonts.body)
                        .foregroundColor(StyleGuide.Colors.primaryText)
                    Spacer()
                    Text(ticket.status)
                        .font(StyleGuide.Fonts.small)
                        .foregroundColor(.gray)
                    Spacer()
                    let pricePerTicket: Decimal? = booking.tickets.count > 0
                        ? booking.totalPrice / Decimal(booking.tickets.count)
                        : nil

                    Text(pricePerTicket?.formatted(.currency(code: "EUR")) ?? "-")
                        .font(StyleGuide.Fonts.small)
                        .foregroundColor(.gray)

                }
            }

            Divider()

            HStack {
                Text("Total:")
                    .font(StyleGuide.Fonts.bodyBold)
                Spacer()
                Text("\(booking.totalPrice.formatted(.currency(code: "EUR")))")
                    .font(StyleGuide.Fonts.bodyBold)
            }
        }
    }
}


#Preview {
    let mockBooking = BookingResponse(
        id: UUID(),
        eventId: UUID(),
        eventTitle: "Concert ONUKA",
        eventLocation: "Maidan Nezalezhnosti, Kyiv, Ukraine",
        eventDateTime: Date().addingTimeInterval(3600),
        expiresAt: Date().addingTimeInterval(900),
        totalPrice: Decimal(1000.00),
        status: "RESERVED",
        paymentIntent: nil,
        tickets: [
            BookingTicketResponse(id: UUID(), userName: "User 1", status: "RESERVED"),
            BookingTicketResponse(id: UUID(), userName: "User 2", status: "RESERVED")
        ]
    )

    return BookingPaymentView(booking: mockBooking)
}
