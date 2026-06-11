//
//  MainTabView.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/MainTabView.swift
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            BudgetsView()
                .tabItem {
                    Label(String(localized: "tab_budgets"), systemImage: "chart.pie.fill")
                }

            TransactionsView(budget: .init(
                id: "", name: "", category: "", limit: 0,
                spent: 0, remainingAmount: 0, spentPercentage: 0,
                color: "#10B981", currency: "EUR",
                isRecurring: false, alertThreshold: 80,
                isAlertTriggered: false, createdAt: .now
            ))

            AnalyticsView()
                .tabItem {
                    Label(String(localized: "tab_analytics"), systemImage: "chart.bar.fill")
                }

            ProfileView()
                .tabItem {
                    Label(String(localized: "tab_profile"), systemImage: "person.fill")
                }
        }
        .tint(.emerald)
    }
}
