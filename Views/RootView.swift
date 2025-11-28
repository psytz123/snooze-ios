// RootView.swift
// Snooze
// Main navigation container
// Modified: 2025-11-28

import SwiftUI
import SwiftData

struct RootView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @StateObject private var snoozeModel = SnoozeModel()

    @State private var showSettings = false
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            SnoozeHostView(
                snoozeModel: snoozeModel,
                showPaywall: $showPaywall
            )
            .navigationTitle("Snooze")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(.primary)
                    }
                    .accessibilityLabel("Settings")
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(subscriptionManager)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
                    .environmentObject(subscriptionManager)
            }
        }
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    RootView()
        .environmentObject(SubscriptionManager())
        .modelContainer(for: Reminder.self, inMemory: true)
}

#Preview("Dark Mode") {
    RootView()
        .environmentObject(SubscriptionManager())
        .modelContainer(for: Reminder.self, inMemory: true)
        .preferredColorScheme(.dark)
}
