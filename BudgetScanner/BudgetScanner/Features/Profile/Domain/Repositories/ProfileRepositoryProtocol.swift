//
//  ProfileRepositoryProtocol.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Profile/Domain/Repositories/ProfileRepositoryProtocol.swift
import Foundation

protocol ProfileRepositoryProtocol {
    func getProfile() async throws -> ProfileEntity
    func updateProfile(name: String, language: String, notifications: Bool) async throws -> ProfileEntity
}
