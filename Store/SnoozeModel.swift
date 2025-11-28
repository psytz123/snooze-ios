// SnoozeModel.swift
// Snooze
// Free tier usage tracking (reminder storage now handled by SwiftData)
// Modified: 2025-11-28

import Foundation
import SwiftUI

/// Tracks free tier usage limits
/// Note: Reminder storage is now handled by SwiftData @Query in views
@MainActor
final class SnoozeModel: ObservableObject {
    /// Number of free snoozes used today
    @AppStorage("freeSnoozesToday") private var freeSnoozesToday: Int = 0

    /// Date string of last snooze (for daily reset)
    @AppStorage("lastSnoozeDay") private var lastSnoozeDay: String = ""

    /// Daily limit for free users
    let freeDailyLimit = 10

    /// Reset counter if it's a new day
    func resetIfNewDay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: Date())

        if todayString != lastSnoozeDay {
            freeSnoozesToday = 0
            lastSnoozeDay = todayString
        }
    }

    /// Remaining free snoozes for today
    var freeRemainingToday: Int {
        resetIfNewDay()
        return max(0, freeDailyLimit - freeSnoozesToday)
    }

    /// Check if a free user can create another snooze
    /// - Parameter isSubscribed: Whether user has Pro subscription
    /// - Returns: True if user can snooze
    func canFreeUserSnooze(isSubscribed: Bool) -> Bool {
        if isSubscribed { return true }
        resetIfNewDay()
        return freeSnoozesToday < freeDailyLimit
    }

    /// Increment the free snooze counter (only for non-subscribers)
    /// - Parameter isSubscribed: Whether user has Pro subscription
    func incrementFreeSnoozeIfNeeded(isSubscribed: Bool) {
        guard !isSubscribed else { return }
        resetIfNewDay()
        freeSnoozesToday += 1
    }
}

// MARK: - Snooze Interval Helpers

extension SnoozeModel {
    /// Calculate seconds until "Tonight" (default 8 PM, configurable)
    /// - Parameter hour: The hour for "tonight" (17-23, default 20)
    /// - Returns: TimeInterval until the target time
    static func secondsUntilTonight(hour: Int = 20) -> TimeInterval {
        var components = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: Date()
        )
        components.hour = hour
        components.minute = 0
        components.second = 0

        guard let tonight = Calendar.current.date(from: components) else {
            // Fallback: 8 hours from now
            return 8 * 60 * 60
        }

        // If target time has passed, schedule for tomorrow
        let target = tonight < Date()
            ? tonight.addingTimeInterval(24 * 60 * 60)
            : tonight

        return target.timeIntervalSinceNow
    }

    /// Preset snooze intervals
    enum SnoozePreset: CaseIterable {
        case thirtyMinutes
        case oneHour
        case tonight

        var label: String {
            switch self {
            case .thirtyMinutes: return "30m"
            case .oneHour: return "1h"
            case .tonight: return "Tonight"
            }
        }

        func seconds(tonightHour: Int = 20) -> TimeInterval {
            switch self {
            case .thirtyMinutes: return 30 * 60
            case .oneHour: return 60 * 60
            case .tonight: return SnoozeModel.secondsUntilTonight(hour: tonightHour)
            }
        }
    }
}
