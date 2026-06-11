//
//  APIConfig.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Core/Config/APIConfig.swift
import Foundation

enum APIConfig {
    static let baseURL = "https://api.castrodev.com/api/budgetscanner"
    static let userMe = "https://api.castrodev.com/api/common/users/me"

    enum Budgets {
        static let base           = "\(baseURL)/budgets"
        static func byId(_ id: String) -> String { "\(base)/\(id)" }
        static let resetRecurring = "\(base)/reset-recurring"
    }

    enum Transactions {
        static let base = "\(baseURL)/transactions"
        static func byId(_ id: String) -> String { "\(base)/\(id)" }
        static func byBudget(_ budgetId: String) -> String { "\(base)?budgetId=\(budgetId)" }
    }

    enum Analytics {
        static func summary(year: Int, month: Int) -> String {
            "\(baseURL)/analytics/summary/\(year)/\(month)"
        }
        static func categories(year: Int, month: Int) -> String {
            "\(baseURL)/analytics/categories/\(year)/\(month)"
        }
        static func comparison(year: Int, month: Int) -> String {
            "\(baseURL)/analytics/comparison/\(year)/\(month)"
        }
    }

    enum Receipts {
        static let scan = "\(baseURL)/receipts/scan"
    }
}
