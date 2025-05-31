import SwiftUI

struct CustomNumberField: View {
    var placeholder: String
    @Binding var value: Int
    var minimum: Int = 0

    @State private var internalText: String = ""

    var body: some View {
        TextField(placeholder, text: $internalText)
            .keyboardType(.numberPad)
            .onAppear {
                internalText = String(value)
            }
            .onChange(of: internalText) {
                if let intValue = Int(internalText), intValue >= minimum {
                    value = intValue
                }
            }

            .padding()
            .background(StyleGuide.Colors.secondaryBackground)
            .cornerRadius(StyleGuide.Corners.medium)
            .foregroundColor(StyleGuide.Colors.primaryText)
            .font(StyleGuide.Fonts.body)
            .shadow(color: StyleGuide.Shadows.color,
                    radius: StyleGuide.Shadows.radius,
                    x: StyleGuide.Shadows.x,
                    y: StyleGuide.Shadows.y)
    }
}
