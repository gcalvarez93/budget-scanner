//
//  TokenProvider.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Core/Network/TokenProvider.swift
import Foundation
import FirebaseAuth

protocol TokenProviderProtocol {
    func getToken() async throws -> String
}

final class FirebaseTokenProvider: TokenProviderProtocol {
    func getToken() async throws -> String {
        guard let user = Auth.auth().currentUser else {
            throw Failure.auth("No authenticated user")
        }
        return try await user.getIDToken()
    }
}
