import SwiftUI


struct CustomDecimalField: View {
    var placeholder: String
    @Binding var value: Decimal
    var minimum: Decimal = 0.0

    @State private var internalText: String = ""

    private let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        f.alwaysShowsDecimalSeparator = true
        return f
    }()

    var body: some View {
        TextField(placeholder, text: $internalText)
            .keyboardType(.decimalPad)
            .onAppear {
                internalText = formatter.string(from: NSDecimalNumber(decimal: value)) ?? ""
            }
            .onChange(of: internalText) {
                let filtered = internalText.replacingOccurrences(of: ",", with: ".")
                if let doubleValue = Double(filtered) {
                    let decimalValue = Decimal(doubleValue)
                    if decimalValue >= minimum {
                        value = decimalValue
                    }
                }
            }
            .onChange(of: value) {
                internalText = formatter.string(from: NSDecimalNumber(decimal: value)) ?? ""
            }
            .padding()
            .background(StyleGuide.Colors.secondaryBackground)
            .cornerRadius(StyleGuide.Corners.medium)
            .foregroundColor(StyleGuide.Colors.primaryText)
            .font(StyleGuide.Fonts.body)
            .shadow(
                color: StyleGuide.Shadows.color,
                radius: StyleGuide.Shadows.radius,
                x: StyleGuide.Shadows.x,
                y: StyleGuide.Shadows.y
            )
    }
}
