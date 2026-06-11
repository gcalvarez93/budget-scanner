//
//  GetCategoryBreakdownUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Analytics/Domain/UseCases/GetCategoryBreakdownUseCase.swift
import Foundation

final class GetCategoryBreakdownUseCase {
    private let repository: AnalyticsRepositoryProtocol

    init(repository: AnalyticsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(year: Int, month: Int) async throws -> [CategoryBreakdownEntity] {
        try await repository.getCategoryBreakdown(year: year, month: month)
    }
}
