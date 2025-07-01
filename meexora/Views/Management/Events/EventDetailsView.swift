import SwiftUI
struct EventDetailsView: View {
    let event: EventManagementResponse

    @State private var alertMessage: String?
    @State private var showAlert = false
    @State private var resumeScanning: (() -> Void)? = nil

    @State private var showScanner = false
    @State private var scannedCode: String?
    @State private var showBox = false
    @StateObject private var viewModel = EventDetailsViewModel()

    var body: some View {
        ScrollView {
            ZStack {
                StyleGuide.Gradients.background
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: StyleGuide.Spacing.large) {
                    VStack(alignment: .leading, spacing: StyleGuide.Spacing.medium) {
                        Text(event.title)
                            .font(StyleGuide.Fonts.largeTitle)
                            .foregroundColor(StyleGuide.Colors.primaryText)

                        Text(event.description)
                            .font(StyleGuide.Fonts.body)
                            .foregroundColor(StyleGuide.Colors.secondaryText)

                        VStack(alignment: .leading, spacing: StyleGuide.Spacing.small) {
                            Text("Address: \(event.address)")
                            Text("Price: \(event.price)€")
                            Text("Date: \(event.date.formatted(date: .abbreviated, time: .shortened))")
                        }
                        .font(StyleGuide.Fonts.body)
                        .foregroundColor(StyleGuide.Colors.primaryText)
                        NavigationLink(destination: EditEventView(eventId: event.id)) {
                            HStack(spacing: 4) {
                                Image(systemName: "pencil")
                                Text("Edit Event")
                            }
                            .font(StyleGuide.Fonts.small)
                            .foregroundColor(StyleGuide.Colors.accentPurple)
                            .underline()
                        }


                        Button("Scan Ticket") {
                            showScanner = true
                        }
                        .modifier(StyleGuide.Buttons.accent())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(StyleGuide.Colors.secondaryBackground)
                    .cornerRadius(StyleGuide.Corners.medium)

                    EventAnalyticsView(eventId: event.id, eventDate: event.date)
                    Spacer()
                }
                .standardPagePadding()
            }
        }
        .sheet(isPresented: $showScanner) {
            ZStack {
                ScannerView(scannedCode: $scannedCode) { code, resume in
                    self.resumeScanning = resume
                    showBox = true

                    Task {
                        await viewModel.validate(scannedCode: code, eventId: event.id)

                        DispatchQueue.main.async {
                            alertMessage = viewModel.validationMessage
                            showAlert = true
                        }
                    }
                }

                if showBox {
                    Rectangle()
                        .strokeBorder(StyleGuide.Colors.accentPurple, lineWidth: 2)
                        .frame(width: 250, height: 250)
                        .transition(.opacity)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Scan Result"),
                    message: Text(alertMessage ?? "Unknown status"),
                    dismissButton: .default(Text("OK")) {
                        showBox = false
                        scannedCode = nil
                        resumeScanning?()
                        resumeScanning = nil
                    }
                )
            }
        }


    }
}


#Preview {
    EventDetailsView(event: EventManagementResponse(
        id: UUID(),
        creatorId: UUID(),
        title: "Local Art Fair",
        description: "An event showcasing local artists, crafts, and live performances.",
        date: Date(),
        latitude: 50.4501,
        longitude: 30.5234,
        address: "Main Square, Kyiv",
        totalTickets: 200,
        price: Decimal(120),
        dynamicPricingEnabled: true,
        minPrice: Decimal(90),
        maxPrice: Decimal(150),
        category: .art
    ))
}
