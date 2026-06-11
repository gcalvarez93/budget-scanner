//
//  AnalyticsViewModel.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Analytics/Presentation/ViewModels/AnalyticsViewModel.swift
import Foundation
import Observation

enum AnalyticsState: Equatable {
    case initial
    case loading
    case loaded
    case error(String)

    static func == (lhs: AnalyticsState, rhs: AnalyticsState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial), (.loading, .loading), (.loaded, .loaded): return true
        case (.error(let a), .error(let b)): return a == b
        default: return false
        }
    }
}

@Observable
final class AnalyticsViewModel {
    var state: AnalyticsState = .initial
    var summary: MonthlySummaryEntity? = nil
    var comparison: MonthComparisonEntity? = nil
    var selectedYear: Int = Calendar.current.component(.year, from: Date())
    var selectedMonth: Int = Calendar.current.component(.month, from: Date())

    private let getMonthlySummary: GetMonthlySummaryUseCase
    private let getMonthComparison: GetMonthComparisonUseCase

    init(
        getMonthlySummary: GetMonthlySummaryUseCase = GetMonthlySummaryUseCase(repository: AnalyticsRepository()),
        getMonthComparison: GetMonthComparisonUseCase = GetMonthComparisonUseCase(repository: AnalyticsRepository())
    ) {
        self.getMonthlySummary = getMonthlySummary
        self.getMonthComparison = getMonthComparison
    }

    func loadAnalytics() async {
        state = .loading
        do {
            async let summaryResult   = getMonthlySummary.execute(year: selectedYear, month: selectedMonth)
            async let comparisonResult = getMonthComparison.execute(year: selectedYear, month: selectedMonth)
            summary    = try await summaryResult
            comparison = try await comparisonResult
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func previousMonth() {
        if selectedMonth == 1 {
            selectedMonth = 12
            selectedYear -= 1
        } else {
            selectedMonth -= 1
        }
        Task { await loadAnalytics() }
    }

    func nextMonth() {
        let now = Date()
        let currentYear  = Calendar.current.component(.year, from: now)
        let currentMonth = Calendar.current.component(.month, from: now)
        guard selectedYear < currentYear || (selectedYear == currentYear && selectedMonth < currentMonth) else { return }

        if selectedMonth == 12 {
            selectedMonth = 1
            selectedYear += 1
        } else {
            selectedMonth += 1
        }
        Task { await loadAnalytics() }
    }

    var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        var components = DateComponents()
        components.year  = selectedYear
        components.month = selectedMonth
        components.day   = 1
        let date = Calendar.current.date(from: components) ?? Date()
        return formatter.string(from: date).capitalized
    }
}
