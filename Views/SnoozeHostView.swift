// SnoozeHostView.swift
// Snooze
// Main content view with reminder list and snooze bar
// Modified: 2025-11-28

import SwiftUI
import SwiftData

struct SnoozeHostView: View {
    // MARK: - Environment & State

    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var subscriptionManager: SubscriptionManager

    /// SwiftData query for upcoming reminders (sorted by time)
    @Query(
        filter: #Predicate<Reminder> { reminder in
            reminder.isCompleted == false
        },
        sort: \Reminder.remindAt,
        order: .forward
    )
    private var reminders: [Reminder]

    /// Free tier tracker
    @ObservedObject var snoozeModel: SnoozeModel

    /// Binding to show paywall when free limit reached
    @Binding var showPaywall: Bool

    /// Tonight hour from settings
    @AppStorage("tonightHour") private var tonightHour: Double = 20.0

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            // Reminder List
            reminderList

            // Bottom overlay
            VStack(spacing: SnoozeSpacing.xs) {
                // Free tier indicator
                if !subscriptionManager.isSubscribed {
                    freeUsageIndicator
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                // Snooze Bar
                SnoozeBar { interval in
                    handleSnooze(interval: interval)
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: subscriptionManager.isSubscribed)
    }

    // MARK: - Reminder List

    private var reminderList: some View {
        Group {
            if upcomingReminders.isEmpty {
                emptyStateView
            } else {
                List {
                    ForEach(upcomingReminders) { reminder in
                        ReminderRow(reminder: reminder)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        deleteReminder(reminder)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }

                                Button {
                                    withAnimation {
                                        markComplete(reminder)
                                    }
                                } label: {
                                    Label("Done", systemImage: "checkmark")
                                }
                                .tint(SnoozeColors.success)
                            }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .contentMargins(.bottom, 140, for: .scrollContent)
            }
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: SnoozeSpacing.md) {
            Spacer()

            Image(systemName: "bell.slash")
                .font(.system(size: 48))
                .foregroundStyle(SnoozeColors.textTertiary)
                .accessibilityHidden(true)

            Text("No Reminders")
                .font(SnoozeTypography.title)
                .foregroundStyle(SnoozeColors.textPrimary)

            Text("Tap a button below to snooze something.")
                .font(SnoozeTypography.body)
                .foregroundStyle(SnoozeColors.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, SnoozeSpacing.lg)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("No reminders. Tap a button below to snooze something.")
    }

    // MARK: - Free Usage Indicator

    private var freeUsageIndicator: some View {
        HStack(spacing: SnoozeSpacing.xxs) {
            Image(systemName: "sparkles")
                .font(.caption2)

            Text("\(snoozeModel.freeRemainingToday) free snoozes left today")
        }
        .font(SnoozeTypography.caption)
        .foregroundStyle(SnoozeColors.textSecondary)
        .padding(.horizontal, SnoozeSpacing.sm)
        .padding(.vertical, SnoozeSpacing.xxs + 2)
        .background(
            Capsule()
                .fill(SnoozeColors.badgeBackground)
        )
        .accessibilityLabel("\(snoozeModel.freeRemainingToday) free snoozes remaining today")
    }

    // MARK: - Helpers

    /// Filter reminders to only show upcoming ones
    private var upcomingReminders: [Reminder] {
        reminders.filter { $0.remindAt > Date() }
    }

    /// Handle snooze button tap
    private func handleSnooze(interval: TimeInterval) {
        let isSubscribed = subscriptionManager.isSubscribed

        // Check free tier limit
        guard snoozeModel.canFreeUserSnooze(isSubscribed: isSubscribed) else {
            showPaywall = true
            return
        }

        // Increment free counter
        snoozeModel.incrementFreeSnoozeIfNeeded(isSubscribed: isSubscribed)

        // Create and save reminder
        let reminder = Reminder(title: "Reminder", delaySeconds: interval)
        modelContext.insert(reminder)

        // Schedule notification
        NotificationService.shared.schedule(reminder: reminder)

        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    /// Delete a reminder
    private func deleteReminder(_ reminder: Reminder) {
        // Cancel the notification
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [reminder.id.uuidString]
        )

        // Delete from SwiftData
        modelContext.delete(reminder)
    }

    /// Mark a reminder as complete
    private func markComplete(_ reminder: Reminder) {
        // Cancel the notification
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [reminder.id.uuidString]
        )

        // Mark as completed (will be filtered out of list)
        reminder.isCompleted = true

        // Success haptic
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

// MARK: - Reminder Row

struct ReminderRow: View {
    let reminder: Reminder
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: SnoozeSpacing.sm) {
            // Reminder info
            VStack(alignment: .leading, spacing: SnoozeSpacing.xxs) {
                Text(reminder.title)
                    .font(SnoozeTypography.body)
                    .foregroundStyle(SnoozeColors.textPrimary)

                HStack(spacing: SnoozeSpacing.xxs) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text(reminder.formattedDate)
                    Text("•")
                    Text(reminder.formattedTime)
                }
                .font(SnoozeTypography.caption)
                .foregroundStyle(SnoozeColors.textSecondary)
            }

            Spacer()

            // Time remaining badge
            timeRemainingBadge
        }
        .padding(.vertical, SnoozeSpacing.xs)
        .padding(.horizontal, SnoozeSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: SnoozeRadius.medium)
                .fill(SnoozeColors.cardBackground)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(reminder.title), \(reminder.formattedDate) at \(reminder.formattedTime)")
        .accessibilityHint("Swipe left for options")
    }

    @ViewBuilder
    private var timeRemainingBadge: some View {
        let remaining = reminder.remindAt.timeIntervalSinceNow

        if remaining > 0 {
            Text(formatTimeRemaining(remaining))
                .font(SnoozeTypography.badge)
                .foregroundStyle(badgeTextColor)
                .padding(.horizontal, SnoozeSpacing.xs)
                .padding(.vertical, SnoozeSpacing.xxs)
                .background(
                    Capsule()
                        .fill(badgeBackgroundColor)
                )
                .accessibilityLabel("\(formatTimeRemaining(remaining)) remaining")
        }
    }

    private var badgeTextColor: Color {
        let remaining = reminder.remindAt.timeIntervalSinceNow
        if remaining < 5 * 60 { // Less than 5 minutes
            return .white
        }
        return SnoozeColors.textSecondary
    }

    private var badgeBackgroundColor: Color {
        let remaining = reminder.remindAt.timeIntervalSinceNow
        if remaining < 5 * 60 { // Less than 5 minutes - urgent
            return SnoozeColors.warning
        }
        return SnoozeColors.badgeBackground
    }

    private func formatTimeRemaining(_ interval: TimeInterval) -> String {
        let minutes = Int(interval / 60)
        let hours = minutes / 60

        if hours > 0 {
            let remainingMinutes = minutes % 60
            if remainingMinutes > 0 {
                return "\(hours)h \(remainingMinutes)m"
            }
            return "\(hours)h"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "<1m"
        }
    }
}

// MARK: - Preview

#Preview("With Reminders - Light") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Reminder.self, configurations: config)

    let context = container.mainContext
    context.insert(Reminder(title: "Call mom", delaySeconds: 30 * 60))
    context.insert(Reminder(title: "Check email", delaySeconds: 60 * 60))
    context.insert(Reminder(title: "Finish report", delaySeconds: 3 * 60 * 60))

    return NavigationStack {
        SnoozeHostView(
            snoozeModel: SnoozeModel(),
            showPaywall: .constant(false)
        )
        .navigationTitle("Snooze")
    }
    .modelContainer(container)
    .environmentObject(SubscriptionManager())
}

#Preview("With Reminders - Dark") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Reminder.self, configurations: config)

    let context = container.mainContext
    context.insert(Reminder(title: "Call mom", delaySeconds: 2 * 60)) // Urgent
    context.insert(Reminder(title: "Check email", delaySeconds: 60 * 60))

    return NavigationStack {
        SnoozeHostView(
            snoozeModel: SnoozeModel(),
            showPaywall: .constant(false)
        )
        .navigationTitle("Snooze")
    }
    .modelContainer(container)
    .environmentObject(SubscriptionManager())
    .preferredColorScheme(.dark)
}

#Preview("Empty State") {
    NavigationStack {
        SnoozeHostView(
            snoozeModel: SnoozeModel(),
            showPaywall: .constant(false)
        )
        .navigationTitle("Snooze")
    }
    .modelContainer(for: Reminder.self, inMemory: true)
    .environmentObject(SubscriptionManager())
}
