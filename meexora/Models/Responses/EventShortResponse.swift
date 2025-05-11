import Foundation

struct EventShortResponse: Identifiable, Decodable {
    let id: UUID
    let creatorId: UUID
    let title: String
    let description: String
    let date: Date
    let latitude: Double
    let longitude: Double
    let address: String
}
