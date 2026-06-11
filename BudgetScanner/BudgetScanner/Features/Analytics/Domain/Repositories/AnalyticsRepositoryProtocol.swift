//
//  AnalyticsRepositoryProtocol.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Analytics/Domain/Repositories/AnalyticsRepositoryProtocol.swift
import Foundation

protocol AnalyticsRepositoryProtocol {
    func getMonthlySummary(year: Int, month: Int) async throws -> MonthlySummaryEntity
    func getCategoryBreakdown(year: Int, month: Int) async throws -> [CategoryBreakdownEntity]
    func getMonthComparison(year: Int, month: Int) async throws -> MonthComparisonEntity
}
