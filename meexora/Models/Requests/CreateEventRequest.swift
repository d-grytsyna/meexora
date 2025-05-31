import Foundation

struct CreateEventRequest: Encodable{
    var title: String = ""
    var description: String = ""
    var date: Date = Date()
    var latitude: Double?
    var longitude: Double?
    var address: String = ""
    var city: String = ""
    var category: EventCategory = .general
    var totalTickets: Int = 1
    var price: Decimal = 10.0
    var dynamicPricingEnabled: Bool = false
    var minPrice: Decimal  = 1.0
    var maxPrice: Decimal  = 100.0

}
