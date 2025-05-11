import Foundation

struct City: Identifiable, Codable {
    var id = UUID()

    let city: String
    let lat: String
    let lng: String
    let country: String
    let iso2: String
    let admin_name: String
    let capital: String?
    let population: String?
    let population_proper: String?

    var name: String { city }

    private enum CodingKeys: String, CodingKey {
        case city, lat, lng, country, iso2, admin_name, capital, population, population_proper
    }
}


@MainActor
final class CitySearchService: ObservableObject {
    @Published var results: [City] = []
    @Published var isLoading: Bool = false

    private var allCities: [City] = []

    init() {
        loadCities()
    }

    private func loadCities() {
        isLoading = true
        defer { isLoading = false }

        guard let url = Bundle.main.url(forResource: "ua", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([City].self, from: data) else {
            print("Failed to load ua.json")
            return
        }

        allCities = decoded.filter {
            if let pop = Int($0.population ?? ""), pop > 10000 {
                return true
            }
            return false
        }
    }

    func searchCity(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard trimmed.count >= 2 else {
            results = []
            return
        }

        results = allCities.filter { $0.city.lowercased().hasPrefix(trimmed) }
                           .prefix(5)
                           .map { $0 }
    }
}
