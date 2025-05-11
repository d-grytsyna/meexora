import SwiftUI

struct LimitedTextField: View {
    let placeholder: String
    @Binding var text: String
    let limit: Int
    let isSecure: Bool
    let keyboard: UIKeyboardType

    var body: some View {
        ZStack(alignment: .center) {
            if text.isEmpty {
                HStack(spacing: 4) {
                    ForEach(0..<limit, id: \.self) { _ in
                        Text("•")
                            .font(StyleGuide.Fonts.title)
                            .foregroundColor(StyleGuide.Colors.secondaryText.opacity(0.4))
                    }
                }
            }

            TextField("", text: $text).keyboardType(keyboard)
            .multilineTextAlignment(.center)
            .onChange(of: text) {
                text = String(text.filter { $0.isNumber }.prefix(limit))
            }
            .foregroundColor(StyleGuide.Colors.primaryText)
            .font(StyleGuide.Fonts.title)
            .padding()
        }
        .background(StyleGuide.Colors.secondaryBackground)
        .cornerRadius(StyleGuide.Corners.medium)
        .shadow(
            color: StyleGuide.Shadows.color,
            radius: StyleGuide.Shadows.radius,
            x: 0,
            y: StyleGuide.Shadows.y
        )
    }
}

