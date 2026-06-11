//
//  MonthComparisonView.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Analytics/Presentation/Components/MonthComparisonView.swift
import SwiftUI

struct MonthComparisonView: View {
    let comparison: MonthComparisonEntity

    private var diffColor: Color {
        comparison.difference > 0 ? Color.errorColor : Color.emerald
    }

    private var diffIcon: String {
        comparison.difference > 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(String(localized: "vs_last_month"))
                .font(.headline)
                .foregroundStyle(Color.primary)

            HStack {
                VStack(spacing: 4) {
                    Text(String(localized: "this_month"))
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                    Text("\(comparison.currentMonthSpent.formatted(.number.precision(.fractionLength(2)))) €")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.primary)
                }

                Spacer()

                VStack(spacing: 4) {
                    Image(systemName: diffIcon)
                        .foregroundStyle(diffColor)
                        .font(.title2)
                    Text("\(abs(comparison.differencePercentage).formatted(.number.precision(.fractionLength(0))))%")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(diffColor)
                }

                Spacer()

                VStack(spacing: 4) {
                    Text(String(localized: "last_month"))
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                    Text("\(comparison.previousMonthSpent.formatted(.number.precision(.fractionLength(2)))) €")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.primary)
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}
