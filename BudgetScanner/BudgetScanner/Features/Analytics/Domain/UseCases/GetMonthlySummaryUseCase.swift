//
//  GetMonthlySummaryUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Analytics/Domain/UseCases/GetMonthlySummaryUseCase.swift
import Foundation

final class GetMonthlySummaryUseCase {
    private let repository: AnalyticsRepositoryProtocol

    init(repository: AnalyticsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(year: Int, month: Int) async throws -> MonthlySummaryEntity {
        try await repository.getMonthlySummary(year: year, month: month)
    }
}
