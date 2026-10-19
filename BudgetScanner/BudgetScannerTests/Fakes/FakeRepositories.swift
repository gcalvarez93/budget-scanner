// Path: BudgetScanner/BudgetScannerTests/Fakes/FakeRepositories.swift
import Foundation
@testable import BudgetScanner

/// Repositorio de autenticación en memoria con resultados configurables.
@MainActor
final class FakeAuthRepository: AuthRepositoryProtocol {
    var signedInUser: UserEntity?
    var loginResult: Result<UserEntity, Failure> = .success(TestData.user)
    var logoutResult: Result<Void, Failure> = .success(())

    func loginWithEmail(email: String, password: String) async throws -> UserEntity {
        try loginResult.get()
    }

    func registerWithEmail(email: String, password: String, name: String) async throws -> UserEntity {
        try loginResult.get()
    }

    func loginWithGoogle() async throws -> UserEntity {
        try loginResult.get()
    }

    func logout() async throws {
        try logoutResult.get()
        signedInUser = nil
    }

    func getCurrentUser() -> UserEntity? {
        signedInUser
    }
}

@MainActor
final class FakeBudgetRepository: BudgetRepositoryProtocol {
    var budgetsResult: Result<[BudgetEntity], Failure> = .success([])
    var createResult: Result<String, Failure> = .success("b-new")
    var updateResult: Result<Void, Failure> = .success(())
    var deleteResult: Result<Void, Failure> = .success(())
    var resetResult: Result<Void, Failure> = .success(())

    private(set) var getBudgetsCalls = 0
    private(set) var createCalls = 0
    private(set) var updatedId: String?
    private(set) var deletedId: String?
    private(set) var resetCalls = 0

    func getBudgets() async throws -> [BudgetEntity] {
        getBudgetsCalls += 1
        return try budgetsResult.get()
    }

    func getBudgetById(id: String) async throws -> BudgetEntity {
        TestData.budget
    }

    func createBudget(name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async throws -> String {
        createCalls += 1
        return try createResult.get()
    }

    func updateBudget(id: String, name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async throws {
        updatedId = id
        try updateResult.get()
    }

    func deleteBudget(id: String) async throws {
        deletedId = id
        try deleteResult.get()
    }

    func resetRecurringBudgets() async throws {
        resetCalls += 1
        try resetResult.get()
    }
}

@MainActor
final class FakeTransactionRepository: TransactionRepositoryProtocol {
    var transactionsResult: Result<[TransactionEntity], Failure> = .success([])
    var createResult: Result<String, Failure> = .success("t-new")
    var updateResult: Result<Void, Failure> = .success(())
    var deleteResult: Result<Void, Failure> = .success(())

    private(set) var getTransactionsCalls = 0
    private(set) var lastBudgetIdFilter: String?
    private(set) var createCalls = 0
    private(set) var updatedId: String?
    private(set) var deletedId: String?

    func getTransactions(budgetId: String?) async throws -> [TransactionEntity] {
        getTransactionsCalls += 1
        lastBudgetIdFilter = budgetId
        return try transactionsResult.get()
    }

    func getTransactionById(id: String) async throws -> TransactionEntity {
        TestData.transaction
    }

    func createTransaction(budgetId: String, category: String, amount: Double, currency: String, description: String, notes: String, tags: [String], receiptImageUrl: String?, merchant: String?, date: Date, isScanned: Bool) async throws -> String {
        createCalls += 1
        return try createResult.get()
    }

    func updateTransaction(id: String, budgetId: String, category: String, amount: Double, currency: String, description: String, notes: String, tags: [String], receiptImageUrl: String?, merchant: String?, date: Date) async throws {
        updatedId = id
        try updateResult.get()
    }

    func deleteTransaction(id: String) async throws {
        deletedId = id
        try deleteResult.get()
    }
}

@MainActor
final class FakeAnalyticsRepository: AnalyticsRepositoryProtocol {
    var summaryResult: Result<MonthlySummaryEntity, Failure> = .success(TestData.summary)
    var comparisonResult: Result<MonthComparisonEntity, Failure> = .success(TestData.comparison)

    private(set) var requestedPeriods: [String] = []

    func getMonthlySummary(year: Int, month: Int) async throws -> MonthlySummaryEntity {
        requestedPeriods.append("\(year)-\(month)")
        return try summaryResult.get()
    }

    func getCategoryBreakdown(year: Int, month: Int) async throws -> [CategoryBreakdownEntity] {
        []
    }

    func getMonthComparison(year: Int, month: Int) async throws -> MonthComparisonEntity {
        try comparisonResult.get()
    }
}

@MainActor
final class FakeProfileRepository: ProfileRepositoryProtocol {
    var profileResult: Result<ProfileEntity, Failure> = .success(TestData.profile)
    var updateResult: Result<ProfileEntity, Failure>?

    func getProfile() async throws -> ProfileEntity {
        try profileResult.get()
    }

    func updateProfile(name: String, language: String, notifications: Bool) async throws -> ProfileEntity {
        if let updateResult {
            return try updateResult.get()
        }
        return ProfileEntity(
            id: TestData.profile.id,
            name: name,
            email: TestData.profile.email,
            photoUrl: nil,
            language: language,
            notifications: notifications
        )
    }
}
