import SwiftUI
import MapKit

struct EventUserInfoView: View {
    let event: EventShortResponse
    @StateObject private var viewModel = EventUserInfoViewModel()
    @State private var isBookingActive = false

    private var eventCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
    }

    private var mapRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: eventCoordinate,
                           span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                StyleGuide.Colors.primaryBackground
                    .ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: StyleGuide.Spacing.extraLarge) {
                        mapView
                        mainCard
                        bookingSection
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .standardPagePadding()
            }
            .navigationDestination(isPresented: $isBookingActive) {
                BookingFormView(event: event, isMonitoringMode: !(viewModel.isAvailable ?? false))
            }
            .navigationTitle(event.title)
            .task {
                await viewModel.checkAvailability(for: event.id)
            }
        }
    }



    private var mapView: some View {
        Map(position: .constant(.region(mapRegion))) {
            Marker(event.title, coordinate: eventCoordinate)
        }
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: StyleGuide.Corners.large))
    }

    private var mainCard: some View {
        VStack(alignment: .leading, spacing: StyleGuide.Spacing.medium) {
            HStack(spacing: 8) {
                Image(event.category.iconNameSmall)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)

                Text(event.title)
                    .font(StyleGuide.Fonts.title)
                    .foregroundColor(StyleGuide.Colors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)

            Text(event.description)
                .font(StyleGuide.Fonts.body)
                .foregroundColor(StyleGuide.Colors.secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: StyleGuide.Spacing.small) {
                Image(systemName: "ticket")
                    .foregroundColor(StyleGuide.Colors.accentBlue)
                Text("Ticket price \(event.price.formatted()) €")
                    .font(StyleGuide.Fonts.bodyBold)
                    .bold()
                    .foregroundColor(StyleGuide.Colors.accentBlue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: StyleGuide.Spacing.small) {
                Image(systemName: "calendar")
                    .foregroundColor(StyleGuide.Colors.accentPurple)
                Text(event.date.formatted(date: .long, time: .shortened))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: StyleGuide.Spacing.small) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(StyleGuide.Colors.accentPurple)
                Text(event.address)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(StyleGuide.Colors.secondaryBackground)
        .cornerRadius(StyleGuide.Corners.medium)
        .frame(maxWidth: .infinity)
    }



    private var bookingSection: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let isAvailable = viewModel.isAvailable {
                Button(isAvailable ? "Book Now" : "Monitor Tickets") {
                    isBookingActive = true
                }
                .modifier(StyleGuide.Buttons.accent())
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .font(StyleGuide.Fonts.small)
                    .foregroundColor(StyleGuide.Colors.errorText)
            }
        }
    }
}

#Preview {
    EventUserInfoView(
        event: EventShortResponse(
            id: UUID(),
            creatorId: UUID(),
            title: "Test Event",
            description: "This is a preview",
            date: Date(),
            latitude: 50.4501,
            longitude: 30.5234,
            address: "Maidan Nezalezhnosti, Kyiv, Ukraine",
            category: .general,
            price: 39
        )
    )
}
