//
//  Failure.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Core/Errors/Failure.swift
import Foundation

enum Failure: LocalizedError, Equatable {
    case network(String)
    case server(String)
    case auth(String)
    case decoding(String)
    case validation(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .network(let msg):  return "Network error: \(msg)"
        case .server(let msg):   return "Server error: \(msg)"
        case .auth(let msg):     return "Auth error: \(msg)"
        case .decoding(let msg): return "Decoding error: \(msg)"
        case .validation(let msg): return msg
        case .unknown:           return "An unknown error occurred"
        }
    }
}
