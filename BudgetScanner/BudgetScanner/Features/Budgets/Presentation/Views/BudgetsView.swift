//
//  BudgetsView.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Budgets/Presentation/Views/BudgetsView.swift
import SwiftUI

struct BudgetsView: View {
    @State private var viewModel = BudgetsViewModel()

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .initial, .loading:
                    ProgressView()
                        .tint(Color.emerald)
                case .loaded(let budgets):
                    if budgets.isEmpty {
                        emptyState
                    } else {
                        budgetsGrid(budgets)
                    }
                case .error(let message):
                    ContentUnavailableView(
                        String(localized: "error"),
                        systemImage: "exclamationmark.triangle",
                        description: Text(message)
                    )
                }
            }
            .navigationTitle(String(localized: "nav_budgets"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.showAddBudget = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: Binding(
                get: { viewModel.showAddBudget },
                set: { viewModel.showAddBudget = $0 }
            )) {
                AddBudgetSheet()
                    .environment(viewModel)
            }
            .sheet(item: Binding(
                get: { viewModel.budgetToEdit },
                set: { viewModel.budgetToEdit = $0 }
            )) { budget in
                AddBudgetSheet(budgetToEdit: budget)
                    .environment(viewModel)
            }
            .task {
                await viewModel.loadBudgets()
            }
            .refreshable {
                await viewModel.loadBudgets()
            }
        }
        .environment(viewModel)
    }

    private var emptyState: some View {
        ContentUnavailableView(
            String(localized: "no_budgets"),
            systemImage: "chart.pie",
            description: Text(String(localized: "no_budgets_description"))
        )
    }

    private func budgetsGrid(_ budgets: [BudgetEntity]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(budgets) { budget in
                    NavigationLink {
                        TransactionsView(budget: budget)
                    } label: {
                        BudgetCardView(budget: budget)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button {
                            viewModel.budgetToEdit = budget
                        } label: {
                            Label(String(localized: "edit"), systemImage: "pencil")
                        }
                        Button(role: .destructive) {
                            Task { await viewModel.removeBudget(id: budget.id) }
                        } label: {
                            Label(String(localized: "delete"), systemImage: "trash")
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
    }
}
