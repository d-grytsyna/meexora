import SwiftUI
import Foundation

@MainActor
class BookingPaymentViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var booking: BookingResponse?;
    @Published var clientSecret: String?
    @Published var paymentCreated: Bool = false
    @Published var secondsRemaining: Int = 0
    @Published var bookingExpired: Bool = false
    @Published var paymentCompleted: Bool = false

    private var timer: Timer?
    var formattedTime: String {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    
    init(booking: BookingResponse) {
        self.booking = booking
        self.clientSecret = booking.paymentIntent?.clientSecret
        self.paymentCreated = self.clientSecret != nil

        guard let expiresAt = booking.expiresAt else {
            self.bookingExpired = true
            self.secondsRemaining = 0
            return
        }

        let remaining = max(Int(expiresAt.timeIntervalSinceNow), 0)
        self.secondsRemaining = remaining

        if remaining > 0 {
            startTimer()
        } else {
            bookingExpired = true
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }

            Task { @MainActor in
                if self.secondsRemaining > 0 {
                    self.secondsRemaining -= 1
                } else {
                    self.timer?.invalidate()
                    self.bookingExpired = true
                }
            }
        }
    }

    
    func retryPaymentIntent() async {
        guard let bookingId = booking?.id else {
            errorMessage = "Missing booking ID"
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await BookingService.retryPaymentIntent(bookingId: bookingId)
            clientSecret = response.paymentIntent?.clientSecret
            paymentCreated = clientSecret != nil
            booking?.paymentIntent = response.paymentIntent
            errorMessage = nil
        } catch {
            errorMessage = "Retrying payment intent failed: \(error.localizedDescription)"
        }
    }
    
}
