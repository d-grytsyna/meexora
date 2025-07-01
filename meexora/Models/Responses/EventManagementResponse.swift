import Foundation

struct EventManagementResponse: Codable, Identifiable {
    var id: UUID
    var creatorId: UUID
    var title: String
    var description: String
    var date: Date
    var latitude: Double
    var longitude: Double
    var address: String
    var totalTickets: Int
    var price: Decimal
    var dynamicPricingEnabled: Bool
    var minPrice: Decimal
    var maxPrice: Decimal
    var category: EventCategory
}
extension EventManagementResponse {
    init() {
        self.init(
            id: UUID(),
            creatorId: UUID(),
            title: "",
            description: "",
            date: Date(),
            latitude: 0.0,
            longitude: 0.0,
            address: "",
            totalTickets: 0,
            price: 0.0,
            dynamicPricingEnabled: false,
            minPrice: 0.0,
            maxPrice: 0.0,
            category: .general
        )
    }
}
