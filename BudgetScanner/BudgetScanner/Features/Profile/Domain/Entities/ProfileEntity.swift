//
//  ProfileEntity.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Profile/Domain/Entities/ProfileEntity.swift
import Foundation

struct ProfileEntity: Equatable {
    let id: String
    let name: String
    let email: String
    let photoUrl: String?
    let language: String
    let notifications: Bool
}
