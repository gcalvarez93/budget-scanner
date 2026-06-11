//
//  UserModel.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Auth/Data/Models/UserModel.swift
import Foundation

struct UserModel: Codable {
    let id: String
    let email: String
    let name: String?
    let photoUrl: String?

    func toEntity() -> UserEntity {
        UserEntity(id: id, email: email, name: name, photoUrl: photoUrl)
    }
}
