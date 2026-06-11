//
//  UserEntity.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Auth/Domain/Entities/UserEntity.swift
import Foundation

struct UserEntity: Equatable {
    let id: String
    let email: String
    let name: String?
    let photoUrl: String?
}
