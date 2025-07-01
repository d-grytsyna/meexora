import SwiftUI

struct CustomFormSection<Content: View>: View {
    let title: String?
    let subtitle: String?
    let content: Content

    init(title: String? = nil, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
        
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = title {
                Text(title)
                    .font(.headline)
                    .foregroundColor(StyleGuide.Colors.secondaryText)

            }
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(StyleGuide.Colors.secondaryText)
            }

            content
        }
        .padding(.vertical, 8)
    }
}
