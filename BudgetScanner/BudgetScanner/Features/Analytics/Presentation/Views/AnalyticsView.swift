//
//  AnalyticsView.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Analytics/Presentation/Views/AnalyticsView.swift
import SwiftUI

struct AnalyticsView: View {
    @State private var viewModel = AnalyticsViewModel()

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .initial, .loading:
                    ProgressView().tint(Color.emerald)
                case .loaded:
                    analyticsContent
                case .error(let message):
                    ContentUnavailableView(
                        String(localized: "error"),
                        systemImage: "exclamationmark.triangle",
                        description: Text(message)
                    )
                }
            }
            .navigationTitle(String(localized: "nav_analytics"))
            .task { await viewModel.loadAnalytics() }
            .refreshable { await viewModel.loadAnalytics() }
        }
    }

    private var analyticsContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Selector de mes
                monthSelector

                // Resumen mensual
                if let summary = viewModel.summary {
                    SummaryCardView(summary: summary)

                    // Top categorías
                    if !summary.topCategories.isEmpty {
                        CategoryBreakdownView(categories: summary.topCategories)
                    }

                    // Presupuestos individuales
                    if !summary.budgets.isEmpty {
                        budgetsList(summary.budgets)
                    }
                }

                // Comparativa
                if let comparison = viewModel.comparison {
                    MonthComparisonView(comparison: comparison)
                }
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
    }

    private var monthSelector: some View {
        HStack {
            Button {
                viewModel.previousMonth()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color.emerald)
                    .font(.title3)
            }

            Spacer()

            Text(viewModel.monthTitle)
                .font(.headline)
                .foregroundStyle(Color.primary)

            Spacer()

            Button {
                viewModel.nextMonth()
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.emerald)
                    .font(.title3)
            }
        }
        .padding(.horizontal, 8)
    }

    private func budgetsList(_ budgets: [BudgetSummaryItemEntity]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "budgets_detail"))
                .font(.headline)
                .foregroundStyle(Color.primary)

            ForEach(budgets, id: \.budgetId) { item in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(hex: item.color))
                        .frame(width: 12, height: 12)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.name)
                            .font(.subheadline)
                            .foregroundStyle(Color.primary)
                        Text(item.category)
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(item.spentPercentage.formatted(.number.precision(.fractionLength(0))))%")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(item.isAlertTriggered ? Color.warningColor : Color.emerald)
                        Text("\(item.spent.formatted(.number.precision(.fractionLength(2)))) / \(item.limit.formatted(.number.precision(.fractionLength(2)))) €")
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}
