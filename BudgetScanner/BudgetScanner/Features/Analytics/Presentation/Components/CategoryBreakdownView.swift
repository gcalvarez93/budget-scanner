//
//  CategoryBreakdownView.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Analytics/Presentation/Components/CategoryBreakdownView.swift
import SwiftUI

struct CategoryBreakdownView: View {
    let categories: [CategoryBreakdownEntity]

    private let colors: [Color] = [
        Color.emerald, Color(hex: "#3B82F6"), Color(hex: "#8B5CF6"),
        Color(hex: "#F59E0B"), Color(hex: "#EF4444")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "by_category"))
                .font(.headline)
                .foregroundStyle(Color.primary)

            ForEach(Array(categories.enumerated()), id: \.offset) { index, cat in
                HStack(spacing: 12) {
                    Circle()
                        .fill(colors[index % colors.count])
                        .frame(width: 10, height: 10)

                    Text(cat.category)
                        .font(.subheadline)
                        .foregroundStyle(Color.primary)

                    Spacer()

                    Text("\(cat.totalSpent.formatted(.number.precision(.fractionLength(2)))) €")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.primary)

                    Text("\(cat.percentage.formatted(.number.precision(.fractionLength(0))))%")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                        .frame(width: 40, alignment: .trailing)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(.systemGray5))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(colors[index % colors.count])
                            .frame(width: geo.size.width * (cat.percentage / 100), height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}
