import SwiftUI


struct CustomDatePicker: View {
    var placeholder: String
    @Binding var selection: Date
    var displayedComponents: DatePickerComponents = [.date, .hourAndMinute]

    var body: some View {
        HStack {
            DatePicker(
                "",
                selection: $selection,
                displayedComponents: displayedComponents
            )
            .labelsHidden()
            .datePickerStyle(.compact)
            .font(StyleGuide.Fonts.body)
            .tint(StyleGuide.Colors.accentPurple)
            Spacer()
        }
        .padding(StyleGuide.Padding.small)
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
