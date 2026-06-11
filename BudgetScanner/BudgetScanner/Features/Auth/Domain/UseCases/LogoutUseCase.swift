//
//  LogoutUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Auth/Domain/UseCases/LogoutUseCase.swift
import Foundation

final class LogoutUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws {
        try await repository.logout()
    }
}
