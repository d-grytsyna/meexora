import SwiftUI

struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(StyleGuide.Fonts.button)
            .foregroundColor(StyleGuide.Colors.buttonText)
            .frame(maxWidth: .infinity)
            .padding()
            .background(StyleGuide.Colors.buttonPrimaryBackground)
            .cornerRadius(StyleGuide.Corners.medium)
            .shadow(color: StyleGuide.Shadows.color, radius: StyleGuide.Shadows.radius, x: StyleGuide.Shadows.x, y: StyleGuide.Shadows.y)
    }
}
