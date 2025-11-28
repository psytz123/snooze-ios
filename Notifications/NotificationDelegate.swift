// NotificationDelegate.swift
// Snooze
// Handles notification action responses (background re-snooze)
// Modified: 2025-11-28

import Foundation
import UserNotifications

/// Handles notification action button taps from lock screen and banner
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()

    private override init() {
        super.init()
    }

    // MARK: - Action Response

    /// Called when user taps a notification action button
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let actionIdentifier = response.actionIdentifier
        let userInfo = response.notification.request.content.userInfo

        switch actionIdentifier {
        case "SNOOZE_15":
            // Re-snooze for 15 minutes
            NotificationService.shared.scheduleSimpleSnooze(in: 15 * 60)
            print("Re-snoozed for 15 minutes")

        case "SNOOZE_60":
            // Re-snooze for 1 hour
            NotificationService.shared.scheduleSimpleSnooze(in: 60 * 60)
            print("Re-snoozed for 1 hour")

        case "MARK_DONE":
            // User marked as done - could update SwiftData here if needed
            if let reminderIdString = userInfo["reminderId"] as? String {
                print("Marked done: \(reminderIdString)")
                // Note: In a more complete implementation, you'd mark
                // the reminder as completed in SwiftData here
            }

        case UNNotificationDefaultActionIdentifier:
            // User tapped the notification itself (opens app)
            print("User tapped notification to open app")

        case UNNotificationDismissActionIdentifier:
            // User dismissed the notification
            print("User dismissed notification")

        default:
            break
        }

        completionHandler()
    }

    // MARK: - Foreground Presentation

    /// Called when a notification arrives while the app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
}
