import SwiftUI

struct CustomTextEditor: View {
    var placeholder: String
    @Binding var text: String
    var minHeight: CGFloat = 120

    @State private var isEditing: Bool = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray.opacity(0.5))
                    .font(StyleGuide.Fonts.body)
                    .padding()
            }

            TextEditor(text: $text)
                .frame(minHeight: minHeight)
                .padding()
                .font(StyleGuide.Fonts.body)
                .foregroundColor(StyleGuide.Colors.primaryText)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        }
        .background(StyleGuide.Colors.secondaryBackground)
        .cornerRadius(StyleGuide.Corners.medium)
        .shadow(color: StyleGuide.Shadows.color,
                radius: StyleGuide.Shadows.radius,
                x: StyleGuide.Shadows.x,
                y: StyleGuide.Shadows.y)
    }
}
