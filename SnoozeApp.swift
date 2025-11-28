// SnoozeApp.swift
// Snooze
// Main app entry point with SwiftData container setup
// Modified: 2025-11-28

import SwiftUI
import SwiftData
import UserNotifications

@main
struct SnoozeApp: App {
    /// Subscription state manager
    @StateObject private var subscriptionManager = SubscriptionManager()

    /// SwiftData model container for persistence
    let modelContainer: ModelContainer

    init() {
        // Initialize SwiftData container
        do {
            let schema = Schema([Reminder.self])
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                allowsSave: true
            )
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }

        // Setup notification delegate
        let center = UNUserNotificationCenter.current()
        center.delegate = NotificationDelegate.shared

        // Request notification permissions and setup categories
        NotificationService.shared.requestAuthorization()
        NotificationService.shared.setupCategories()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(subscriptionManager)
        }
        .modelContainer(modelContainer)
    }
}
