//
//  AnalyticsRemoteDataSource.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Analytics/Data/DataSources/AnalyticsRemoteDataSource.swift
import Foundation

protocol AnalyticsRemoteDataSourceProtocol {
    func getMonthlySummary(year: Int, month: Int) async throws -> MonthlySummaryModel
    func getCategoryBreakdown(year: Int, month: Int) async throws -> [CategoryBreakdownModel]
    func getMonthComparison(year: Int, month: Int) async throws -> MonthComparisonModel
}

final class AnalyticsRemoteDataSource: AnalyticsRemoteDataSourceProtocol {
    private let client: NetworkClientProtocol

    init(client: NetworkClientProtocol = NetworkClient.shared) {
        self.client = client
    }

    func getMonthlySummary(year: Int, month: Int) async throws -> MonthlySummaryModel {
        try await client.get(APIConfig.Analytics.summary(year: year, month: month))
    }

    func getCategoryBreakdown(year: Int, month: Int) async throws -> [CategoryBreakdownModel] {
        try await client.get(APIConfig.Analytics.categories(year: year, month: month))
    }

    func getMonthComparison(year: Int, month: Int) async throws -> MonthComparisonModel {
        try await client.get(APIConfig.Analytics.comparison(year: year, month: month))
    }
}
