// SnoozeTheme.swift
// Snooze
// Centralized color and styling definitions for dark/light mode
// Modified: 2025-11-28

import SwiftUI

// MARK: - Snooze Color Palette

/// Centralized color definitions for consistent theming
enum SnoozeColors {
    // MARK: - Snooze Bar Colors

    /// Background color for the snooze bar container
    static var barBackground: Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor.systemGray6
                : UIColor.systemGray5.withAlphaComponent(0.95)
        })
    }

    /// Background color for snooze buttons
    static var buttonBackground: Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor.systemGray5
                : UIColor.systemGray4
        })
    }

    /// Text color for snooze buttons (high contrast)
    static var buttonText: Color {
        .white
    }

    // MARK: - Card Colors

    /// Background for card-style containers
    static var cardBackground: Color {
        Color(uiColor: .secondarySystemGroupedBackground)
    }

    /// Subtle background for badges and chips
    static var badgeBackground: Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor.systemGray5
                : UIColor.systemGray6
        })
    }

    // MARK: - Accent Colors

    /// Primary accent color
    static var accent: Color {
        .blue
    }

    /// Success state color
    static var success: Color {
        .green
    }

    /// Warning state color
    static var warning: Color {
        .orange
    }

    /// Error state color
    static var error: Color {
        .red
    }

    // MARK: - Text Colors

    /// Primary text color
    static var textPrimary: Color {
        Color(uiColor: .label)
    }

    /// Secondary text color
    static var textSecondary: Color {
        Color(uiColor: .secondaryLabel)
    }

    /// Tertiary text color
    static var textTertiary: Color {
        Color(uiColor: .tertiaryLabel)
    }

    // MARK: - Shadow

    /// Standard shadow color
    static var shadow: Color {
        Color.black.opacity(0.1)
    }

    /// Darker shadow for elevated elements
    static var shadowDark: Color {
        Color.black.opacity(0.2)
    }
}

// MARK: - Snooze Typography

/// Centralized typography definitions
enum SnoozeTypography {
    /// Large title style
    static let largeTitle = Font.largeTitle.weight(.bold)

    /// Title style
    static let title = Font.title.weight(.semibold)

    /// Headline style
    static let headline = Font.headline

    /// Body style
    static let body = Font.body

    /// Caption style
    static let caption = Font.caption

    /// Button text style
    static let button = Font.system(size: 15, weight: .semibold)

    /// Badge text style
    static let badge = Font.caption.weight(.medium)
}

// MARK: - Snooze Spacing

/// Consistent spacing values
enum SnoozeSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Snooze Corner Radius

/// Consistent corner radius values
enum SnoozeRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xlarge: CGFloat = 20
    static let pill: CGFloat = 999
}

// MARK: - View Modifiers

/// Card-style background modifier
struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: SnoozeRadius.large)
                    .fill(SnoozeColors.cardBackground)
            )
    }
}

/// Pill badge modifier
struct PillBadge: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(SnoozeTypography.badge)
            .foregroundStyle(SnoozeColors.textSecondary)
            .padding(.horizontal, SnoozeSpacing.sm)
            .padding(.vertical, SnoozeSpacing.xxs + 2)
            .background(
                Capsule()
                    .fill(SnoozeColors.badgeBackground)
            )
    }
}

extension View {
    /// Apply card-style background
    func cardStyle() -> some View {
        modifier(CardBackground())
    }

    /// Apply pill badge styling
    func pillBadge() -> some View {
        modifier(PillBadge())
    }
}

// MARK: - Preview

#Preview("Color Palette - Light") {
    ScrollView {
        VStack(spacing: 20) {
            Group {
                Text("Snooze Bar Background")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(SnoozeColors.barBackground)

                Text("Button Background")
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(SnoozeColors.buttonBackground)

                Text("Card Background")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(SnoozeColors.cardBackground)

                Text("Badge Background")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(SnoozeColors.badgeBackground)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))

            HStack(spacing: 12) {
                Circle().fill(SnoozeColors.accent).frame(width: 40)
                Circle().fill(SnoozeColors.success).frame(width: 40)
                Circle().fill(SnoozeColors.warning).frame(width: 40)
                Circle().fill(SnoozeColors.error).frame(width: 40)
            }

            Text("Sample Badge")
                .pillBadge()
        }
        .padding()
    }
}

#Preview("Color Palette - Dark") {
    ScrollView {
        VStack(spacing: 20) {
            Group {
                Text("Snooze Bar Background")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(SnoozeColors.barBackground)

                Text("Button Background")
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(SnoozeColors.buttonBackground)

                Text("Card Background")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(SnoozeColors.cardBackground)

                Text("Badge Background")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(SnoozeColors.badgeBackground)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
