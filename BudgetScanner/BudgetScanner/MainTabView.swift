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
