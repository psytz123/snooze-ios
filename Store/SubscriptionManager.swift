// SubscriptionManager.swift
// Snooze
// StoreKit 2 subscription management
// Modified: 2025-11-28

import Foundation
import StoreKit
import SwiftUI

/// Manages Snooze Pro subscription state using StoreKit 2
@MainActor
final class SubscriptionManager: ObservableObject {
    // MARK: - Configuration

    /// Product ID for the monthly subscription
    /// TODO: Replace with your real product ID from App Store Connect
    /// Format: com.yourcompany.snooze.pro.monthly
    private let subscriptionProductID = "com.yourcompany.snooze.pro.monthly"

    // MARK: - Published State

    /// Whether the user has an active subscription
    @Published private(set) var isSubscribed: Bool = false

    /// Available products from the App Store
    @Published private(set) var products: [Product] = []

    /// Loading state for purchase/restore operations
    @Published var isLoading: Bool = false

    /// Error message for UI display
    @Published var errorMessage: String?

    // MARK: - Transaction Listener

    private var transactionListener: Task<Void, Never>?

    // MARK: - Initialization

    init() {
        // Start listening for transaction updates
        transactionListener = listenForTransactions()

        // Load products and check subscription status
        Task {
            await loadProducts()
            await updateSubscriptionStatus()
        }
    }

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Transaction Listener

    /// Listen for transaction updates (renewals, refunds, etc.)
    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    await self?.updateSubscriptionStatus()
                }
            }
        }
    }

    // MARK: - Product Loading

    /// Load subscription products from the App Store
    func loadProducts() async {
        do {
            isLoading = true
            errorMessage = nil

            let storeProducts = try await Product.products(for: [subscriptionProductID])
            self.products = storeProducts

            if storeProducts.isEmpty {
                print("Warning: No products found for ID: \(subscriptionProductID)")
            }
        } catch {
            self.errorMessage = "Failed to load subscription options."
            print("StoreKit product load error: \(error)")
        }
        isLoading = false
    }

    // MARK: - Purchase

    /// Initiate a subscription purchase
    func purchase() async {
        guard let product = products.first(where: { $0.id == subscriptionProductID }) else {
            errorMessage = "Subscription product not available."
            return
        }

        do {
            isLoading = true
            errorMessage = nil

            let result = try await product.purchase()

            switch result {
            case .success(let verificationResult):
                switch verificationResult {
                case .verified(let transaction):
                    await transaction.finish()
                    await updateSubscriptionStatus()
                case .unverified(_, let error):
                    errorMessage = "Purchase verification failed."
                    print("Transaction verification failed: \(error)")
                }

            case .userCancelled:
                // User cancelled, no error needed
                break

            case .pending:
                // Transaction is pending (e.g., Ask to Buy)
                errorMessage = "Purchase pending approval."

            @unknown default:
                errorMessage = "Unknown purchase result."
            }
        } catch {
            errorMessage = "Purchase failed. Please try again."
            print("Purchase error: \(error)")
        }
        isLoading = false
    }

    // MARK: - Restore

    /// Restore previous purchases
    func restore() async {
        do {
            isLoading = true
            errorMessage = nil

            try await AppStore.sync()
            await updateSubscriptionStatus()

            if !isSubscribed {
                errorMessage = "No active subscription found."
            }
        } catch {
            errorMessage = "Restore failed. Please try again."
            print("Restore error: \(error)")
        }
        isLoading = false
    }

    // MARK: - Subscription Status

    /// Update the subscription status by checking current entitlements
    func updateSubscriptionStatus() async {
        var subscribed = false

        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productType == .autoRenewable &&
                    transaction.productID == subscriptionProductID {
                    // Check if not expired and not revoked
                    if transaction.revocationDate == nil {
                        subscribed = true
                        break
                    }
                }
            }
        }

        self.isSubscribed = subscribed
    }
}

// MARK: - Product Helpers

extension SubscriptionManager {
    /// Get the subscription product (if loaded)
    var subscriptionProduct: Product? {
        products.first(where: { $0.id == subscriptionProductID })
    }

    /// Formatted price string for display
    var priceDisplayString: String {
        subscriptionProduct?.displayPrice ?? "—"
    }

    /// Subscription period description
    var periodDescription: String {
        guard let product = subscriptionProduct,
              let subscription = product.subscription else {
            return ""
        }

        let unit = subscription.subscriptionPeriod.unit
        let value = subscription.subscriptionPeriod.value

        switch unit {
        case .day: return value == 1 ? "daily" : "every \(value) days"
        case .week: return value == 1 ? "weekly" : "every \(value) weeks"
        case .month: return value == 1 ? "monthly" : "every \(value) months"
        case .year: return value == 1 ? "yearly" : "every \(value) years"
        @unknown default: return ""
        }
    }
}
