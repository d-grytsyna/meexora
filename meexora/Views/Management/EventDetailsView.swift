import SwiftUI

struct EventDetailsView: View {
    let event: EventManagementResponse

    @State private var showScanner = false
    @State private var scannedCode: String?
    @State private var showBox = false
    @StateObject private var viewModel = EventDetailsViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(event.title).font(.largeTitle).bold()
            Text(event.description)
            Text("Address: \(event.address)")
            Text("Price: \(event.price)₴")
            Text("Date: \(event.date.formatted(date: .abbreviated, time: .shortened))")

            Button("Scan Ticket") {
                showScanner = true
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)

            if let message = viewModel.validationMessage {
                Text(message)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(10)
            }
        }
        .padding()
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
                        .strokeBorder(Color.green, lineWidth: 3)
                        .frame(width: 250, height: 250)
                        .transition(.opacity)
                }

                if let message = viewModel.validationMessage {
                    VStack {
                        Spacer()
                        Text(message)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 40)
                    }
                }
            }
        }
    }
}
