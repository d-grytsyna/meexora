import Foundation

struct SalesStatsResponse: Codable {
    let dailySales: [DailySale]
    let totalTicketsSold: Int
    let totalRevenue: Decimal
}

struct DailySale: Codable, Identifiable {
    var id: String { date.description } 
    let date: Date
    let ticketsSold: Int
    let totalPrice: Decimal
    
    init(date: Date, ticketsSold: Int, totalPrice: Decimal) {
        self.date = date
        self.ticketsSold = ticketsSold
        self.totalPrice = totalPrice
    }

    enum CodingKeys: String, CodingKey {
        case date, ticketsSold, totalPrice
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let dateString = try container.decode(String.self, forKey: .date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let parsedDate = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .date,
                                                    in: container,
                                                    debugDescription: "Invalid date format")
        }

        self.date = parsedDate
        self.ticketsSold = try container.decode(Int.self, forKey: .ticketsSold)
        self.totalPrice = try container.decode(Decimal.self, forKey: .totalPrice)
    }
}
