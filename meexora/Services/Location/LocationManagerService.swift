import Foundation
import CoreLocation

struct DetectedLocation: Equatable {
    let city: String
    let country: String?
}

@MainActor
final class LocationManagerService: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()

    @Published var detectedLocation: DetectedLocation?
    @Published var locationDenied = false
    @Published var isLoading = false

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
}

extension LocationManagerService: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        Task { @MainActor in
            print("Authorization changed: \(status.rawValue)")
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                manager.requestLocation()
            } else if status == .denied || status == .restricted {
                self.locationDenied = true
                self.isLoading = false
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            print("Location error: \(error.localizedDescription)")
            self.isLoading = false
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        Task { @MainActor in
            print("LocationManager: got coordinates: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            self.isLoading = false
            let geocoder = CLGeocoder()
            let placemarks = try? await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks?.first,
               let city = placemark.locality {
                self.detectedLocation = DetectedLocation(city: city, country: placemark.country)
                print("Detected city: \(city)")
            } else {
                print("Reverse geocoding failed or city not found")
            }
        }
    }
}
