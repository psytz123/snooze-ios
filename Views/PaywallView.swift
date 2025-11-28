// PaywallView.swift
// Snooze
// Subscription upgrade UI with feature highlights
// Modified: 2025-11-28

import SwiftUI
import StoreKit

/// Clean, focused paywall for Snooze Pro subscription
struct PaywallView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    headerSection

                    // Features
                    featuresSection

                    // Pricing
                    pricingSection

                    // Purchase Button
                    purchaseButton

                    // Restore Link
                    restoreButton

                    // Free tier note
                    freeNoteSection
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Upgrade")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 12) {
            // App Icon placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)

                Image(systemName: "bell.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.white)
            }
            .shadow(color: .blue.opacity(0.3), radius: 12, y: 6)

            Text("Snooze Pro")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Never miss a reminder again")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 20)
    }

    // MARK: - Features

    private var featuresSection: some View {
        VStack(spacing: 16) {
            FeatureRow(
                icon: "infinity",
                title: "Unlimited Snoozes",
                description: "No daily limits on how many reminders you can set"
            )

            FeatureRow(
                icon: "moon.stars.fill",
                title: "Custom Tonight Time",
                description: "Set your preferred evening reminder time"
            )

            FeatureRow(
                icon: "sparkles",
                title: "Future Pro Features",
                description: "Widgets, Siri shortcuts, and more coming soon"
            )

            FeatureRow(
                icon: "heart.fill",
                title: "Support Development",
                description: "Help us keep building great features"
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    // MARK: - Pricing

    private var pricingSection: some View {
        VStack(spacing: 8) {
            if let product = subscriptionManager.subscriptionProduct {
                Text(product.displayPrice)
                    .font(.system(size: 44, weight: .bold))

                Text(subscriptionManager.periodDescription.capitalized)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("Auto-renewing subscription. Cancel anytime.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                ProgressView()
                    .padding()
                Text("Loading pricing...")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Purchase Button

    private var purchaseButton: some View {
        Button {
            Task {
                await subscriptionManager.purchase()
                if subscriptionManager.isSubscribed {
                    dismiss()
                }
            }
        } label: {
            HStack {
                if subscriptionManager.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Continue")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.accentColor)
            )
            .foregroundStyle(.white)
        }
        .disabled(subscriptionManager.isLoading || subscriptionManager.products.isEmpty)

        // Error message
        if let error = subscriptionManager.errorMessage {
            Text(error)
                .font(.caption)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Restore

    private var restoreButton: some View {
        Button {
            Task {
                await subscriptionManager.restore()
                if subscriptionManager.isSubscribed {
                    dismiss()
                }
            }
        } label: {
            Text("Restore Purchases")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .disabled(subscriptionManager.isLoading)
    }

    // MARK: - Free Note

    private var freeNoteSection: some View {
        Text("You can continue using the free version with 10 snoozes per day.")
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.bottom, 20)
    }
}

// MARK: - Feature Row

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }
}

// MARK: - Preview

#Preview("Paywall - Light") {
    PaywallView()
        .environmentObject(SubscriptionManager())
}

#Preview("Paywall - Dark") {
    PaywallView()
        .environmentObject(SubscriptionManager())
        .preferredColorScheme(.dark)
}
