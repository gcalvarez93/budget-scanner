//
//  AuthRepositoryProtocol.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Auth/Domain/Repositories/AuthRepositoryProtocol.swift
import Foundation

protocol AuthRepositoryProtocol {
    func loginWithEmail(email: String, password: String) async throws -> UserEntity
    func registerWithEmail(email: String, password: String, name: String) async throws -> UserEntity
    func loginWithGoogle() async throws -> UserEntity
    func logout() async throws
    func getCurrentUser() -> UserEntity?
}
