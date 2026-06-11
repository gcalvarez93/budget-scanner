//
//  UpdateProfileUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Profile/Domain/UseCases/UpdateProfileUseCase.swift
import Foundation

final class UpdateProfileUseCase {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute(name: String, language: String, notifications: Bool) async throws -> ProfileEntity {
        try await repository.updateProfile(name: name, language: language, notifications: notifications)
    }
}
