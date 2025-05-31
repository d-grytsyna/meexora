import SwiftUI

struct CustomPicker<T: Hashable>: View {
    var title: String
    var options: [T]
    @Binding var selection: T
    var labelProvider: (T) -> String
    var iconNameProvider: (T) -> String

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button {
                    selection = option
                } label: {
                    HStack {
                        Image(iconNameProvider(option))
                            .resizable()
                            .frame(width: 20, height: 20)
                            .cornerRadius(4)
                        Text(labelProvider(option))
                    }
                }
            }
        } label: {
            HStack {
                Image(iconNameProvider(selection))
                    .resizable()
                    .frame(width: 20, height: 20)
                    .cornerRadius(4)
                Text(labelProvider(selection))
                    .foregroundColor(StyleGuide.Colors.primaryText)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(StyleGuide.Colors.secondaryBackground)
            .cornerRadius(StyleGuide.Corners.medium)
            .shadow(
                color: StyleGuide.Shadows.color,
                radius: StyleGuide.Shadows.radius,
                x: StyleGuide.Shadows.x,
                y: StyleGuide.Shadows.y
            )
        }
    }
}
