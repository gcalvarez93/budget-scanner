//
//  SummaryCardView.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Analytics/Presentation/Components/SummaryCardView.swift
import SwiftUI

struct SummaryCardView: View {
    let summary: MonthlySummaryEntity

    private var progressColor: Color {
        if summary.overallSpentPercentage >= 100 { return Color.errorColor }
        if summary.overallSpentPercentage >= 80  { return Color.warningColor }
        return Color.emerald
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(localized: "total_spent"))
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                    Text("\(summary.totalSpent.formatted(.number.precision(.fractionLength(2)))) €")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.primary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(String(localized: "total_budgeted"))
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                    Text("\(summary.totalBudgeted.formatted(.number.precision(.fractionLength(2)))) €")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.primary)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.systemGray5))
                        .frame(height: 10)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(progressColor)
                        .frame(width: geo.size.width * min(summary.overallSpentPercentage / 100, 1), height: 10)
                }
            }
            .frame(height: 10)

            HStack {
                Text("\(summary.overallSpentPercentage.formatted(.number.precision(.fractionLength(0))))% \(String(localized: "used"))")
                    .font(.caption)
                    .foregroundStyle(progressColor)
                Spacer()
                if summary.alertsTriggered > 0 {
                    Label("\(summary.alertsTriggered) \(String(localized: "alerts"))", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundStyle(Color.warningColor)
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}
