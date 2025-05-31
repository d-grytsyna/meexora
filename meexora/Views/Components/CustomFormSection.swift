import SwiftUI

struct CustomFormSection<Content: View>: View {
    let title: String?
    let content: Content

    init(title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = title {
                Text(title)
                    .font(.headline)
                    .foregroundColor(StyleGuide.Colors.secondaryText)
            }

            content
        }
        .padding(.vertical, 8)
    }
}
