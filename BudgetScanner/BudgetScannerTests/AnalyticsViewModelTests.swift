// Path: BudgetScanner/BudgetScannerTests/AnalyticsViewModelTests.swift
import Foundation
import Testing
@testable import BudgetScanner

@MainActor
struct AnalyticsViewModelTests {
    private let repository = FakeAnalyticsRepository()

    private func makeViewModel() -> AnalyticsViewModel {
        AnalyticsViewModel(
            getMonthlySummary: GetMonthlySummaryUseCase(repository: repository),
            getMonthComparison: GetMonthComparisonUseCase(repository: repository)
        )
    }

    @Test func loadAnalyticsExposesSummaryAndComparison() async {
        let viewModel = makeViewModel()

        await viewModel.loadAnalytics()

        #expect(viewModel.state == .loaded)
        #expect(viewModel.summary?.totalSpent == TestData.summary.totalSpent)
        #expect(viewModel.comparison?.difference == TestData.comparison.difference)
    }

    @Test func loadAnalyticsRequestsTheSelectedMonth() async {
        let viewModel = makeViewModel()
        viewModel.selectedYear = 2026
        viewModel.selectedMonth = 3

        await viewModel.loadAnalytics()

        #expect(repository.requestedPeriods == ["2026-3"])
    }

    @Test func loadAnalyticsFailureShowsTheMessage() async {
        repository.summaryResult = .failure(.server("HTTP 500"))
        let viewModel = makeViewModel()

        await viewModel.loadAnalytics()

        #expect(viewModel.state == .error("Server error: HTTP 500"))
    }

    @Test func previousMonthFromJanuaryGoesToDecemberOfThePreviousYear() {
        let viewModel = makeViewModel()
        viewModel.selectedYear = 2026
        viewModel.selectedMonth = 1

        viewModel.previousMonth()

        #expect(viewModel.selectedYear == 2025)
        #expect(viewModel.selectedMonth == 12)
    }

    @Test func previousMonthWithinTheYearOnlyChangesTheMonth() {
        let viewModel = makeViewModel()
        viewModel.selectedYear = 2026
        viewModel.selectedMonth = 5

        viewModel.previousMonth()

        #expect(viewModel.selectedYear == 2026)
        #expect(viewModel.selectedMonth == 4)
    }

    @Test func nextMonthDoesNotGoBeyondTheCurrentMonth() {
        let viewModel = makeViewModel()
        let now = Date()
        let year = Calendar.current.component(.year, from: now)
        let month = Calendar.current.component(.month, from: now)
        viewModel.selectedYear = year
        viewModel.selectedMonth = month

        viewModel.nextMonth()

        #expect(viewModel.selectedYear == year)
        #expect(viewModel.selectedMonth == month)
    }

    @Test func nextMonthFromDecemberOfAPastYearGoesToJanuary() {
        let viewModel = makeViewModel()
        viewModel.selectedYear = 2020
        viewModel.selectedMonth = 12

        viewModel.nextMonth()

        #expect(viewModel.selectedYear == 2021)
        #expect(viewModel.selectedMonth == 1)
    }
}
