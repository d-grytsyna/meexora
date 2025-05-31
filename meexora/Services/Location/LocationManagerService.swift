import Foundation
import CoreLocation

struct DetectedLocation: Equatable {
    let city: String
    let country: String?
}


@MainActor
final class LocationManagerService: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    static let shared = LocationManagerService()
    @Published var detectedLocation: DetectedLocation?
    @Published var locationDenied = false
    @Published var isLoading = false

    private var locationContinuation: CheckedContinuation<CLLocation, Error>?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestCityDetection() {
        isLoading = true
        locationDenied = false

        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationDenied = true
            isLoading = false
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        default:
            isLoading = false
        }
    }

    func getCurrentLocation() async throws -> CLLocationCoordinate2D {
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .denied || status == .restricted {
            throw URLError(.noPermissionsToReadFile)
        }

        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            locationManager.requestLocation()
        }.coordinate
    }

    func hasLocationPermission() -> Bool {
        let status = locationManager.authorizationStatus
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
}

extension LocationManagerService: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        Task { @MainActor in
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                manager.requestLocation()
            } else if status == .denied || status == .restricted {
                self.locationDenied = true
                self.isLoading = false
                self.locationContinuation?.resume(throwing: URLError(.noPermissionsToReadFile))
                self.locationContinuation = nil
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.isLoading = false
            self.locationContinuation?.resume(throwing: error)
            self.locationContinuation = nil
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        Task { @MainActor in
            self.isLoading = false
            self.locationContinuation?.resume(returning: location)
            self.locationContinuation = nil

            let geocoder = CLGeocoder()
            let placemarks = try? await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks?.first,
               let city = placemark.locality {
                self.detectedLocation = DetectedLocation(city: city, country: placemark.country)
            }
        }
    }
}
