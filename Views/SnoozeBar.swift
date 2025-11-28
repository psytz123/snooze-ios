// SnoozeBar.swift
// Snooze
// Compact, non-intrusive snooze preset buttons
// Modified: 2025-11-28

import SwiftUI

/// Compact, non-intrusive Snooze bar with three presets.
/// Designed for minimal cognitive load - one tap to snooze.
struct SnoozeBar: View {
    /// Callback when a snooze interval is selected
    let onSnooze: (TimeInterval) -> Void

    /// Tonight hour from user settings
    @AppStorage("tonightHour") private var tonightHour: Double = 20.0

    /// Environment for accessibility
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    /// Preset button definitions
    private var presets: [(label: String, seconds: TimeInterval, accessibilityLabel: String)] {
        [
            ("30m", 30 * 60, "30 minutes"),
            ("1h", 60 * 60, "1 hour"),
            ("Tonight", SnoozeModel.secondsUntilTonight(hour: Int(tonightHour)), "Tonight at \(Int(tonightHour)):00")
        ]
    }

    var body: some View {
        HStack(spacing: SnoozeSpacing.xs + 2) {
            ForEach(presets, id: \.label) { preset in
                SnoozeButton(
                    label: preset.label,
                    accessibilityLabel: "Snooze for \(preset.accessibilityLabel)"
                ) {
                    onSnooze(preset.seconds)
                }
            }
        }
        .padding(.horizontal, SnoozeSpacing.sm + 2)
        .padding(.vertical, SnoozeSpacing.xs + 2)
        .background(
            RoundedRectangle(cornerRadius: SnoozeRadius.xlarge)
                .fill(SnoozeColors.barBackground)
                .shadow(color: SnoozeColors.shadow, radius: 8, y: 4)
        )
        .padding(.horizontal, SnoozeSpacing.lg - 4)
        .padding(.bottom, SnoozeSpacing.lg)
    }
}

// MARK: - Snooze Button

struct SnoozeButton: View {
    let label: String
    let accessibilityLabel: String
    let action: () -> Void

    @State private var isPressed = false
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(SnoozeTypography.button)
                .foregroundStyle(SnoozeColors.buttonText)
                .padding(.horizontal, SnoozeSpacing.md)
                .padding(.vertical, SnoozeSpacing.xs + 2)
                .background(
                    RoundedRectangle(cornerRadius: SnoozeRadius.medium)
                        .fill(SnoozeColors.buttonBackground)
                )
                .opacity(isEnabled ? 1.0 : 0.5)
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(.plain)
        .pressEvents(
            onPress: { isPressed = true },
            onRelease: { isPressed = false }
        )
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("Double tap to set reminder")
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Press Events Modifier

extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        self.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in onPress() }
                .onEnded { _ in onRelease() }
        )
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    VStack {
        Spacer()
        SnoozeBar { interval in
            print("Snooze for \(interval) seconds")
        }
    }
    .background(Color(.systemBackground))
}

#Preview("Dark Mode") {
    VStack {
        Spacer()
        SnoozeBar { interval in
            print("Snooze for \(interval) seconds")
        }
    }
    .background(Color(.systemBackground))
    .preferredColorScheme(.dark)
}

#Preview("Large Dynamic Type") {
    VStack {
        Spacer()
        SnoozeBar { interval in
            print("Snooze for \(interval) seconds")
        }
    }
    .background(Color(.systemBackground))
    .dynamicTypeSize(.xxxLarge)
}
