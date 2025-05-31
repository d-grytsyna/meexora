import Foundation
import SwiftUI

@MainActor
final class EventUserListViewModel: ObservableObject {
    @AppStorage("userCity") private var cachedCity: String = ""

    @Published var events: [EventShortResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCategory: EventCategory? = nil
    @Published var mode: EventSearchMode = .city
    @Published var isLocationAvailable: Bool = false

    @Published var currentPage: Int = 0
    private var totalPages: Int = 1
    private let pageSize = 10
    private var isFetching = false

    func updateMode(to newMode: EventSearchMode) async {
        mode = newMode
        await resetAndFetch()
    }

    func checkLocationAvailability() async {
        do {
            _ = try await LocationManagerService.shared.getCurrentLocation()
            isLocationAvailable = true
        } catch {
            isLocationAvailable = false
        }
    }

    func fetchNextPageIfNeeded(currentItem: EventShortResponse?) async {
        guard let currentItem = currentItem else { return }
        guard let lastItem = events.last, currentItem.id == lastItem.id else { return }

        await fetchPage()
    }

    func resetAndFetch() async {
        events = []
        currentPage = 0
        totalPages = 1
        await fetchPage()
    }

    private func fetchPage() async {
        guard !isFetching, currentPage < totalPages else { return }

        isFetching = true
        errorMessage = nil
        defer { isFetching = false }

        do {
            var cityToUse = cachedCity
            if cityToUse.isEmpty {
                let profile = try await UserService.getProfile()
                cachedCity = profile.location
                cityToUse = profile.location
            }

            let cityName = cityToUse.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            let response: PaginatedResponse<EventShortResponse>

            switch mode {
            case .city:
                response = try await EventService.getPaginatedEvents(
                    city: cityName,
                    category: selectedCategory,
                    page: currentPage,
                    size: pageSize
                )
            case .nearby:
                let location = try await LocationManagerService.shared.getCurrentLocation()
                response = try await EventService.getNearbyEvents(
                    latitude: location.latitude,
                    longitude: location.longitude,
                    category: selectedCategory,
                    page: currentPage,
                    size: pageSize
                )
            }

            events.append(contentsOf: response.content)
            currentPage += 1
            totalPages = response.totalPages
        } catch {
            print("Error fetching events:", error.localizedDescription)
            errorMessage = "Failed to load events"
        }
    }
}
