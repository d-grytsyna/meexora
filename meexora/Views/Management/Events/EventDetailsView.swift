import SwiftUI
struct EventDetailsView: View {
    let event: EventManagementResponse

    @State private var showScanner = false
    @State private var scannedCode: String?
    @State private var showBox = false
    @StateObject private var viewModel = EventDetailsViewModel()

    var body: some View {
        ScrollView{
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
            .sheet(isPresented: $showScanner) {
                ZStack {
                    ScannerView(scannedCode: $scannedCode) { code in
                        showBox = true
                        Task {
                            await viewModel.validate(scannedCode: code, eventId: event.id)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                showBox = false
                                scannedCode = nil
                            }
                        }
                    }
                    
                    if showBox {
                        Rectangle()
                            .strokeBorder(StyleGuide.Colors.accentPurple, lineWidth: 1)
                            .frame(width: 250, height: 250)
                            .transition(.opacity)
                    }
                }
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
        maxPrice: Decimal(150)
    ))
}
