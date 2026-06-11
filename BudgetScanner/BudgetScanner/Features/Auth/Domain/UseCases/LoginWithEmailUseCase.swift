//
//  LoginWithEmailUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Auth/Domain/UseCases/LoginWithEmailUseCase.swift
import Foundation

final class LoginWithEmailUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(email: String, password: String) async throws -> UserEntity {
        guard !email.isEmpty, !password.isEmpty else {
            throw Failure.auth("Email and password cannot be empty")
        }
        return try await repository.loginWithEmail(email: email, password: password)
    }
}
