//
//  LoginWithGoogleUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Auth/Domain/UseCases/LoginWithGoogleUseCase.swift
import Foundation

final class LoginWithGoogleUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> UserEntity {
        try await repository.loginWithGoogle()
    }
}
