import SwiftUI

struct StyleGuide {
    
    // MARK: - Colors
    struct Colors {
        // Фон
        static let primaryBackground = Color(red: 0.97, green: 0.97, blue: 0.97) // світло-сіруватий фон
        static let secondaryBackground = Color(red: 0.92, green: 0.92, blue: 0.95) // ще світліший

        // Основні акценти
        static let accentBlue = Color(red: 0.3, green: 0.6, blue: 1.0) // м'який голубий
        static let accentPurple = Color(red: 0.6, green: 0.4, blue: 0.9) // м'який фіолетовий
        static let accentYellow = Color(red: 1.0, green: 0.85, blue: 0.4) // теплий ніжний жовтий

        static let accentGradientStart = Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.55) // голубий
        static let accentGradientEnd = Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.55) // фіолетовий

        // Тексти
        static let primaryText = Color(red: 0.2, green: 0.2, blue: 0.25) // темно-сірий
        static let secondaryText = Color(red: 0.5, green: 0.5, blue: 0.6) // світліший сірий
        static let whiteText = primaryBackground

        // Кнопки
        static let buttonPrimaryBackground = accentYellow
        static let buttonSecondaryBackground = accentPurple
        static let buttonText = Color.white

        // Помилки
        static let errorText = Color(red: 0.9, green: 0.2, blue: 0.2)
        
        // UIColor для UIKit
        static let accentPurpleUIColor = UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 1.0)

    }
    // MARK: - Fonts
    struct Fonts {
        static let largeTitle = Font.system(size: 32, weight: .bold)
        static let title = Font.system(size: 24, weight: .semibold)
        static let bodyBold = Font.system(size: 16, weight: .bold)
        static let body = Font.system(size: 16)
        static let button = Font.system(size: 18, weight: .semibold)
        static let small = Font.system(size: 14)
    }
    
    // MARK: - Gradients
    struct Gradients2 {
        static let background = LinearGradient(
            gradient: Gradient(colors: [Colors.accentGradientStart, Colors.accentGradientEnd]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Button Styles
    struct Buttons {
        static func primary() -> some ViewModifier {
            PrimaryButtonStyle()
        }
        
        static func accent() -> some ViewModifier {
            AccentButtonStyle()
        }
    }
    
    
    
    // MARK: - Spacing
    struct Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
    }
    
    struct Padding {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
    }
    struct Corners {
            static let small: CGFloat = 8
            static let medium: CGFloat = 12
            static let large: CGFloat = 16
        }
        
    struct Shadows {
        static let color: Color = .black.opacity(0.2)
        static let radius: CGFloat = 4
        static let x: CGFloat = 0
        static let y: CGFloat = 2
        
    }
}
