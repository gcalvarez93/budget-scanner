//
//  BudgetCardView.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Budgets/Presentation/Components/BudgetCardView.swift
import SwiftUI

struct BudgetCardView: View {
    let budget: BudgetEntity

    private var budgetColor: Color {
        Color(hex: budget.color)
    }

    private var progressColor: Color {
        if budget.spentPercentage >= 100 { return Color.errorColor }
        if budget.isAlertTriggered { return Color.warningColor }
        return Color.emerald
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(budgetColor)
                    .frame(width: 36, height: 36)

                Spacer()

                if budget.isAlertTriggered {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color.warningColor)
                        .font(.caption)
                }
            }

            // Name & category
            VStack(alignment: .leading, spacing: 2) {
                Text(budget.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)

                Text(budget.category)
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 6)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(progressColor)
                        .frame(width: geo.size.width * min(budget.spentPercentage / 100, 1), height: 6)
                }
            }
            .frame(height: 6)

            // Amounts
            HStack {
                Text("\(budget.spent.formatted(.number.precision(.fractionLength(0)))) \(budget.currency)")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)

                Spacer()

                Text("\(budget.spentPercentage.formatted(.number.precision(.fractionLength(0))))%")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(progressColor)
            }

            Text(String(localized: "of_limit \(budget.limit.formatted(.number.precision(.fractionLength(0)))) \(budget.currency)"))
                .font(.caption2)
                .foregroundStyle(Color.textSecondary)
        }
        .padding(14)
        .background(Color.bgCard)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
