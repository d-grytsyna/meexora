import Foundation



@MainActor
class BookingListViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var bookings: [BookingResponse] = []
    @Published var selectedTab: BookingTab = .monitoring
    
    var filteredBookings: [BookingResponse] {
        switch selectedTab {
        case .monitoring:
            return bookings.filter { $0.status == "WATCHING" }
        case .reserved:
            return bookings.filter { $0.status == "RESERVED" }
        case .paid:
            return bookings.filter { $0.status == "PAID" }
        case .history:
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            return bookings.filter {
                if $0.status == "REFUND" || $0.status == "REFUND_FAILED" {
                    return true
                }
                
                return $0.status == "PAID" && $0.eventDateTime < yesterday
            }
        }
    }
    
    func loadBookings() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await BookingService.fetchAllBookings()
            bookings = result
        } catch {
            print("Booking fetch error: \(error)")
            errorMessage = error.localizedDescription 
        }
    }

}
    
