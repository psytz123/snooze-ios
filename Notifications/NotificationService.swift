// NotificationService.swift
// Snooze
// Local notification scheduling and category management
// Modified: 2025-11-28

import Foundation
import UserNotifications

/// Manages local notification scheduling and categories for Snooze reminders
final class NotificationService {
    static let shared = NotificationService()

    private init() {}

    // MARK: - Category Identifiers

    private enum CategoryID {
        static let snoozeReminder = "SNOOZE_REMINDER"
    }

    private enum ActionID {
        static let snooze15 = "SNOOZE_15"
        static let snooze60 = "SNOOZE_60"
        static let markDone = "MARK_DONE"
    }

    // MARK: - Authorization

    /// Request notification permissions from the user
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error)")
            }
            print("Notification permission granted: \(granted)")
        }
    }

    /// Check current authorization status
    func checkAuthorizationStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }

    // MARK: - Category Setup

    /// Configure notification categories with action buttons
    func setupCategories() {
        let snooze15Action = UNNotificationAction(
            identifier: ActionID.snooze15,
            title: "15m",
            options: []
        )

        let snooze60Action = UNNotificationAction(
            identifier: ActionID.snooze60,
            title: "1h",
            options: []
        )

        let doneAction = UNNotificationAction(
            identifier: ActionID.markDone,
            title: "Done",
            options: [.authenticationRequired]
        )

        let snoozeCategory = UNNotificationCategory(
            identifier: CategoryID.snoozeReminder,
            actions: [snooze15Action, snooze60Action, doneAction],
            intentIdentifiers: [],
            options: []
        )

        UNUserNotificationCenter.current().setNotificationCategories([snoozeCategory])
    }

    // MARK: - Scheduling

    /// Schedule a notification for a reminder
    /// - Parameter reminder: The Reminder to schedule
    func schedule(reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "Snooze"
        content.body = reminder.title
        content.sound = .default
        content.categoryIdentifier = CategoryID.snoozeReminder

        // Add reminder ID to userInfo for tracking
        content.userInfo = ["reminderId": reminder.id.uuidString]

        // Calculate interval (minimum 5 seconds)
        let interval = max(5, reminder.remindAt.timeIntervalSinceNow)

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: interval,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: reminder.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }

    /// Schedule a simple re-snooze notification (from notification action)
    /// - Parameter seconds: Delay in seconds
    func scheduleSimpleSnooze(in seconds: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Snooze"
        content.body = "Snoozed reminder"
        content.sound = .default
        content.categoryIdentifier = CategoryID.snoozeReminder

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: max(5, seconds),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule re-snooze: \(error)")
            }
        }
    }

    // MARK: - Cancellation

    /// Cancel a scheduled notification
    /// - Parameter reminderId: The reminder ID to cancel
    func cancel(reminderId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [reminderId.uuidString]
        )
    }

    /// Cancel all pending notifications
    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // MARK: - Badge Management

    /// Clear the app badge
    func clearBadge() {
        UNUserNotificationCenter.current().setBadgeCount(0) { error in
            if let error = error {
                print("Failed to clear badge: \(error)")
            }
        }
    }
}
