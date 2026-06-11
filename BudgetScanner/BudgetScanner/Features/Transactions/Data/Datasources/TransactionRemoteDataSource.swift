//
//  TransactionRemoteDataSource.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Transactions/Data/DataSources/TransactionRemoteDataSource.swift
import Foundation

protocol TransactionRemoteDataSourceProtocol {
    func getTransactions(budgetId: String?) async throws -> [TransactionModel]
    func getTransactionById(id: String) async throws -> TransactionModel
    func createTransaction(_ request: CreateTransactionRequest) async throws -> String
    func updateTransaction(id: String, request: UpdateTransactionRequest) async throws
    func deleteTransaction(id: String) async throws
}

final class TransactionRemoteDataSource: TransactionRemoteDataSourceProtocol {
    private let client: NetworkClientProtocol

    init(client: NetworkClientProtocol = NetworkClient.shared) {
        self.client = client
    }

    func getTransactions(budgetId: String?) async throws -> [TransactionModel] {
        let url = budgetId != nil
            ? APIConfig.Transactions.byBudget(budgetId!)
            : APIConfig.Transactions.base
        return try await client.get(url)
    }

    func getTransactionById(id: String) async throws -> TransactionModel {
        try await client.get(APIConfig.Transactions.byId(id))
    }

    func createTransaction(_ request: CreateTransactionRequest) async throws -> String {
        let encoded = try JSONEncoder().encode(request)
        let json = String(data: encoded, encoding: .utf8) ?? "nil"
        print("CreateTransaction body: \(json)")
        return try await client.post(APIConfig.Transactions.base, body: request)
    }

    func updateTransaction(id: String, request: UpdateTransactionRequest) async throws {
        let _: String = try await client.put(APIConfig.Transactions.byId(id), body: request)
    }

    func deleteTransaction(id: String) async throws {
        try await client.delete(APIConfig.Transactions.byId(id))
    }
}
