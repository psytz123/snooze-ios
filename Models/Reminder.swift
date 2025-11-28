// Reminder.swift
// Snooze
// SwiftData model for persistent reminder storage
// Modified: 2025-11-28

import Foundation
import SwiftData

/// Persistent reminder model using SwiftData
/// Stores snooze reminders with automatic iCloud sync support (when enabled)
@Model
final class Reminder {
    /// Unique identifier for notification management
    var id: UUID

    /// User-facing reminder title (defaults to "Reminder")
    var title: String

    /// Timestamp when the reminder was created
    var createdAt: Date

    /// Scheduled notification time
    var remindAt: Date

    /// Whether the reminder has been completed/dismissed
    var isCompleted: Bool

    init(
        id: UUID = UUID(),
        title: String = "Reminder",
        createdAt: Date = Date(),
        remindAt: Date,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.remindAt = remindAt
        self.isCompleted = isCompleted
    }

    /// Convenience initializer for creating a reminder with a delay interval
    convenience init(title: String = "Reminder", delaySeconds: TimeInterval) {
        self.init(
            title: title,
            remindAt: Date().addingTimeInterval(delaySeconds)
        )
    }
}

// MARK: - Computed Properties

extension Reminder {
    /// Check if the reminder is still upcoming (not past due)
    var isUpcoming: Bool {
        remindAt > Date() && !isCompleted
    }

    /// Formatted time string for display
    var formattedTime: String {
        remindAt.formatted(date: .omitted, time: .shortened)
    }

    /// Formatted date string for display
    var formattedDate: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(remindAt) {
            return "Today"
        } else if calendar.isDateInTomorrow(remindAt) {
            return "Tomorrow"
        } else {
            return remindAt.formatted(date: .abbreviated, time: .omitted)
        }
    }
}
