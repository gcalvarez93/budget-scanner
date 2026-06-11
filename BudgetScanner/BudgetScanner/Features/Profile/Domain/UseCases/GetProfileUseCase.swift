//
//  GetProfileUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Profile/Domain/UseCases/GetProfileUseCase.swift
import Foundation

final class GetProfileUseCase {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> ProfileEntity {
        try await repository.getProfile()
    }
}
