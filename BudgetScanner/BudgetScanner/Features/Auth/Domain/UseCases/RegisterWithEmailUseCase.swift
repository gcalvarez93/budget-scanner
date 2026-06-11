//
//  RegisterWithEmailUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Auth/Domain/UseCases/RegisterWithEmailUseCase.swift
import Foundation

final class RegisterWithEmailUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(email: String, password: String, name: String) async throws -> UserEntity {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty else {
            throw Failure.auth("All fields are required")
        }
        guard password.count >= 6 else {
            throw Failure.auth("Password must be at least 6 characters")
        }
        return try await repository.registerWithEmail(email: email, password: password, name: name)
    }
}
