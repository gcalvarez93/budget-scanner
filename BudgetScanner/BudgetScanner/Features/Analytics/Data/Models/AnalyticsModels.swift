//
//  AnalyticsModels.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Analytics/Data/Models/AnalyticsModels.swift
import Foundation

struct MonthlySummaryModel: Codable {
    let year: Int
    let month: Int
    let totalBudgeted: Double
    let totalSpent: Double
    let totalRemaining: Double
    let overallSpentPercentage: Double
    let budgets: [BudgetSummaryItemModel]
    let topCategories: [CategoryBreakdownModel]
    let alertsTriggered: Int

    func toEntity() -> MonthlySummaryEntity {
        MonthlySummaryEntity(
            year: year, month: month,
            totalBudgeted: totalBudgeted,
            totalSpent: totalSpent,
            totalRemaining: totalRemaining,
            overallSpentPercentage: overallSpentPercentage,
            budgets: budgets.map { $0.toEntity() },
            topCategories: topCategories.map { $0.toEntity() },
            alertsTriggered: alertsTriggered
        )
    }
}

struct BudgetSummaryItemModel: Codable {
    let budgetId: String
    let name: String
    let category: String
    let color: String
    let limit: Double
    let spent: Double
    let spentPercentage: Double
    let isAlertTriggered: Bool

    func toEntity() -> BudgetSummaryItemEntity {
        BudgetSummaryItemEntity(
            budgetId: budgetId, name: name,
            category: category, color: color,
            limit: limit, spent: spent,
            spentPercentage: spentPercentage,
            isAlertTriggered: isAlertTriggered
        )
    }
}

struct CategoryBreakdownModel: Codable {
    let category: String
    let totalSpent: Double
    let transactionCount: Int
    let percentage: Double

    func toEntity() -> CategoryBreakdownEntity {
        CategoryBreakdownEntity(
            category: category,
            totalSpent: totalSpent,
            transactionCount: transactionCount,
            percentage: percentage
        )
    }
}

struct MonthComparisonModel: Codable {
    let currentYear: Int
    let currentMonth: Int
    let currentMonthSpent: Double
    let previousYear: Int
    let previousMonth: Int
    let previousMonthSpent: Double
    let difference: Double
    let differencePercentage: Double
    let categoryComparisons: [CategoryComparisonModel]

    func toEntity() -> MonthComparisonEntity {
        MonthComparisonEntity(
            currentYear: currentYear, currentMonth: currentMonth,
            currentMonthSpent: currentMonthSpent,
            previousYear: previousYear, previousMonth: previousMonth,
            previousMonthSpent: previousMonthSpent,
            difference: difference,
            differencePercentage: differencePercentage,
            categoryComparisons: categoryComparisons.map { $0.toEntity() }
        )
    }
}

struct CategoryComparisonModel: Codable {
    let category: String
    let currentSpent: Double
    let previousSpent: Double
    let difference: Double

    func toEntity() -> CategoryComparisonEntity {
        CategoryComparisonEntity(
            category: category,
            currentSpent: currentSpent,
            previousSpent: previousSpent,
            difference: difference
        )
    }
}
