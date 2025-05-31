import Foundation

@MainActor
class EventAnalyticsViewModel: ObservableObject {
    
    private let eventId: UUID
    private let eventDate: Date

    init(eventId: UUID, eventDate: Date) {
        self.eventId = eventId
        self.eventDate = eventDate
    }
    
    @Published var salesStatsResponse: SalesStatsResponse?
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    func fetchAllData() async {
        isLoading = true
        defer { isLoading = false }

        async let salesTask: () = fetchSalesData()
        _ = await (salesTask)
    }

    func fetchSalesData() async {
        isLoading = true
        error = nil
        
        do {
            let response = try await BookingService.getTicketSales(eventId: eventId)
            let completedDailySales = generateFullDailyStats(to: eventDate, stats: response.dailySales)
            
            salesStatsResponse = SalesStatsResponse(
                dailySales: completedDailySales,
                totalTicketsSold: response.totalTicketsSold,
                totalRevenue: response.totalRevenue
            )
        } catch {
            self.error = "Failed to get stats for event : \(error.localizedDescription)"
        }
        
        isLoading = false
    }

    func generateFullDailyStats(to eventDate: Date, stats: [DailySale]) -> [DailySale] {
        guard let firstDate = stats.map({ $0.date.stripTime() }).min(), !stats.isEmpty else {
            return stats;
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastDate = min(today, eventDate.stripTime())
        
        guard let days = calendar.dateComponents([.day], from: firstDate, to: lastDate).day else {
            return stats
        }

        let statMap = Dictionary(uniqueKeysWithValues: stats.map { ($0.date.stripTime(), $0) })

        return (0...days).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: firstDate) else { return nil }
            let day = date.stripTime()
            return statMap[day] ?? DailySale(date: day, ticketsSold: 0, totalPrice: 0)
        }
    }



    
}
extension Date {
    func stripTime() -> Date {
        Calendar.current.startOfDay(for: self)
    }
}
