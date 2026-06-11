//
//  AnalyticsRepository.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Analytics/Data/Repositories/AnalyticsRepository.swift
import Foundation

final class AnalyticsRepository: AnalyticsRepositoryProtocol {
    private let dataSource: AnalyticsRemoteDataSourceProtocol

    init(dataSource: AnalyticsRemoteDataSourceProtocol = AnalyticsRemoteDataSource()) {
        self.dataSource = dataSource
    }

    func getMonthlySummary(year: Int, month: Int) async throws -> MonthlySummaryEntity {
        let model = try await dataSource.getMonthlySummary(year: year, month: month)
        return model.toEntity()
    }

    func getCategoryBreakdown(year: Int, month: Int) async throws -> [CategoryBreakdownEntity] {
        let models = try await dataSource.getCategoryBreakdown(year: year, month: month)
        return models.map { $0.toEntity() }
    }

    func getMonthComparison(year: Int, month: Int) async throws -> MonthComparisonEntity {
        let model = try await dataSource.getMonthComparison(year: year, month: month)
        return model.toEntity()
    }
}
