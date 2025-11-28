// SettingsView.swift
// Snooze
// User preferences and subscription management
// Modified: 2025-11-28

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var subscriptionManager: SubscriptionManager

    @AppStorage("tonightHour") private var tonightHour: Double = 20.0

    var body: some View {
        NavigationStack {
            Form {
                // Subscription Status Section
                subscriptionSection

                // Tonight Time Section
                tonightSection

                // About Section
                aboutSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: - Subscription Section

    private var subscriptionSection: some View {
        Section {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Snooze Pro")
                        .font(.headline)

                    if subscriptionManager.isSubscribed {
                        Text("Active")
                            .font(.caption)
                            .foregroundStyle(.green)
                    } else {
                        Text("Unlock unlimited snoozes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                if subscriptionManager.isSubscribed {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                        .font(.title2)
                } else {
                    Text(subscriptionManager.priceDisplayString)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)

            if !subscriptionManager.isSubscribed {
                Button {
                    Task {
                        await subscriptionManager.purchase()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Upgrade to Pro")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .disabled(subscriptionManager.isLoading)

                Button {
                    Task {
                        await subscriptionManager.restore()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Restore Purchases")
                            .font(.subheadline)
                        Spacer()
                    }
                }
                .disabled(subscriptionManager.isLoading)
            }

            if let error = subscriptionManager.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        } header: {
            Text("Subscription")
        } footer: {
            if !subscriptionManager.isSubscribed {
                Text("Free users get 10 snoozes per day. Pro unlocks unlimited snoozes and all future features.")
            }
        }
    }

    // MARK: - Tonight Section

    private var tonightSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Tonight time")
                    Spacer()
                    Text(formatHour(Int(tonightHour)))
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }

                Slider(value: $tonightHour, in: 17...23, step: 1) {
                    Text("Tonight hour")
                } minimumValueLabel: {
                    Text("5 PM")
                        .font(.caption2)
                } maximumValueLabel: {
                    Text("11 PM")
                        .font(.caption2)
                }
                .tint(.accentColor)
            }
            .padding(.vertical, 4)
        } header: {
            Text("Snooze Timing")
        } footer: {
            Text("The \"Tonight\" button will snooze until this time. If it's already past this hour, it snoozes until tomorrow.")
        }
    }

    // MARK: - About Section

    private var aboutSection: some View {
        Section {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundStyle(.secondary)
            }

            Link(destination: URL(string: "https://yourwebsite.com/privacy")!) {
                HStack {
                    Text("Privacy Policy")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Link(destination: URL(string: "https://yourwebsite.com/terms")!) {
                HStack {
                    Text("Terms of Service")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        } header: {
            Text("About")
        }
    }

    // MARK: - Helpers

    private func formatHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        var components = DateComponents()
        components.hour = hour
        components.minute = 0

        if let date = Calendar.current.date(from: components) {
            return formatter.string(from: date)
        }
        return "\(hour):00"
    }
}

// MARK: - Preview

#Preview("Free User") {
    SettingsView()
        .environmentObject(SubscriptionManager())
}

#Preview("Dark Mode") {
    SettingsView()
        .environmentObject(SubscriptionManager())
        .preferredColorScheme(.dark)
}
