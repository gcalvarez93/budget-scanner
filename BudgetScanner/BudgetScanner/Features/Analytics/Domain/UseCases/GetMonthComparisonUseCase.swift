//
//  GetMonthComparisonUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Analytics/Domain/UseCases/GetMonthComparisonUseCase.swift
import Foundation

final class GetMonthComparisonUseCase {
    private let repository: AnalyticsRepositoryProtocol

    init(repository: AnalyticsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(year: Int, month: Int) async throws -> MonthComparisonEntity {
        try await repository.getMonthComparison(year: year, month: month)
    }
}
