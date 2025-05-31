import Foundation

struct EventResponse: Decodable, Identifiable {
    let id: UUID
    let creatorId: UUID
    let title: String
    let description: String
    let date: Date
    let latitude: Double
    let longitude: Double
    let address: String
    let totalTickets: Int
    let price: Decimal
    let dynamicPricingEnabled: Bool
    let minPrice: Decimal
    let maxPrice: Decimal
    let category: EventCategory
}
