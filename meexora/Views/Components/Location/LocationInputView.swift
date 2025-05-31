import SwiftUI
import MapKit
import CoreLocation

struct LocationInputView: View {
    @Binding var latitude: Double?
    @Binding var longitude: Double?
    @Binding var address: String
    @Binding var city: String

    @State private var searchQuery = ""
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    @StateObject private var autocomplete = AutocompleteController()

    init(latitude: Binding<Double?>, longitude: Binding<Double?>, address: Binding<String>,  city: Binding<String>) {
        self._latitude = latitude
        self._longitude = longitude
        self._address = address
        self._city = city
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                if address.isEmpty {
                    CustomTextField(placeholder: "Search address", text: $searchQuery,  isSecure: false)

                } else {
                    ZStack {
                        StyleGuide.Colors.secondaryBackground
                            .cornerRadius(StyleGuide.Corners.medium)
                            .shadow(
                                color: StyleGuide.Shadows.color,
                                radius: StyleGuide.Shadows.radius,
                                x: StyleGuide.Shadows.x,
                                y: StyleGuide.Shadows.y
                            )

                        Text(searchQuery)
                            .foregroundColor(StyleGuide.Colors.primaryText)
                            .font(StyleGuide.Fonts.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }


                }

                if !address.isEmpty {
                    Button(action: {
                        clearSearch()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }

            if !autocomplete.results.isEmpty && address.isEmpty {
                List(autocomplete.results, id: \.self) { result in
                    Button {
                        selectAddress(result)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(result.title)
                            if !result.subtitle.isEmpty {
                                Text(result.subtitle)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .frame(height: 200)
            }

            TapDetectingMapView(coordinate: $selectedCoordinate)
                .frame(height: 300)
                .cornerRadius(StyleGuide.Corners.medium)
                .onChange(of: selectedCoordinate) {
                    guard let coord = selectedCoordinate else { return }
                    reverseGeocode(coord: coord)
                }
        }
        .onAppear {
            if let lat = latitude, let lon = longitude {
                selectedCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                searchQuery = address
            }
        }
        .onChange(of: searchQuery) {
            if address.isEmpty {
                autocomplete.updateQuery(searchQuery)
            }
        }
    }

    private func selectAddress(_ completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)

        search.start { response, error in
            guard let item = response?.mapItems.first else { return }

            let coord = item.placemark.coordinate
            selectedCoordinate = coord
            latitude = coord.latitude
            longitude = coord.longitude

            let fullAddress = item.placemark.title ?? ""
            address = fullAddress
            searchQuery = fullAddress
            city = item.placemark.locality?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            autocomplete.clear()
        }
    }

    private func reverseGeocode(coord: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else { return }

            let formatted = [
                placemark.name,
                placemark.locality,
                placemark.country
            ].compactMap { $0 }.joined(separator: ", ")

            address = formatted
            searchQuery = formatted
            latitude = coord.latitude
            longitude = coord.longitude
            city = placemark.locality?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            autocomplete.clear()
        }
    }

    private func clearSearch() {
        searchQuery = ""
        address = ""
        city = ""
        latitude = nil
        longitude = nil
        selectedCoordinate = nil
        autocomplete.clear()
    }
}
