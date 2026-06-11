//
//  TransactionsView.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Transactions/Presentation/Views/TransactionsView.swift
import SwiftUI

struct TransactionsView: View {
    let budget: BudgetEntity
    @State private var viewModel: TransactionsViewModel

    init(budget: BudgetEntity) {
        self.budget = budget
        self._viewModel = State(initialValue: TransactionsViewModel(budget: budget))
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .initial, .loading:
                ProgressView()
                    .tint(Color.emerald)
            case .loaded(let transactions):
                if transactions.isEmpty {
                    emptyState
                } else {
                    transactionsList(transactions)
                }
            case .error(let message):
                ContentUnavailableView(
                    String(localized: "error"),
                    systemImage: "exclamationmark.triangle",
                    description: Text(message)
                )
            }
        }
        .navigationTitle(budget.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.showAddTransaction = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: Binding(
            get: { viewModel.showAddTransaction },
            set: { viewModel.showAddTransaction = $0 }
        )) {
            AddTransactionSheet()
                .environment(viewModel)
        }
        .sheet(item: Binding(
            get: { viewModel.transactionToEdit },
            set: { viewModel.transactionToEdit = $0 }
        )) { transaction in
            AddTransactionSheet(transactionToEdit: transaction)
                .environment(viewModel)
        }
        .task {
            await viewModel.loadTransactions()
        }
        .refreshable {
            await viewModel.loadTransactions()
        }
        .environment(viewModel)
    }

    private var emptyState: some View {
        ContentUnavailableView(
            String(localized: "no_transactions"),
            systemImage: "creditcard",
            description: Text(String(localized: "no_transactions_description"))
        )
    }

    private func transactionsList(_ transactions: [TransactionEntity]) -> some View {
        List {
            // Budget summary card
            Section {
                BudgetSummaryRow(budget: budget)
            }

            // Transactions grouped by date
            let grouped = Dictionary(grouping: transactions) { transaction in
                Calendar.current.startOfDay(for: transaction.date)
            }
            let sortedDates = grouped.keys.sorted(by: >)

            ForEach(sortedDates, id: \.self) { date in
                Section(date.formatted(date: .long, time: .omitted)) {
                    ForEach(grouped[date] ?? []) { transaction in
                        TransactionRowView(transaction: transaction)
                            .contextMenu {
                                Button {
                                    viewModel.transactionToEdit = transaction
                                } label: {
                                    Label(String(localized: "edit"), systemImage: "pencil")
                                }
                                Button(role: .destructive) {
                                    Task { await viewModel.removeTransaction(id: transaction.id) }
                                } label: {
                                    Label(String(localized: "delete"), systemImage: "trash")
                                }
                            }
                    }
                }
            }
        }
    }
}

// Mini resumen del presupuesto en la parte superior de la lista
private struct BudgetSummaryRow: View {
    let budget: BudgetEntity

    private var progressColor: Color {
        if budget.spentPercentage >= 100 { return Color.errorColor }
        if budget.isAlertTriggered { return Color.warningColor }
        return Color.emerald
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(String(localized: "spent"))
                    .font(.subheadline)
                    .foregroundStyle(Color.textSecondary)
                Spacer()
                Text("\(budget.spent.formatted(.number.precision(.fractionLength(2)))) / \(budget.limit.formatted(.number.precision(.fractionLength(2)))) \(budget.currency)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(progressColor)
                        .frame(width: geo.size.width * min(budget.spentPercentage / 100, 1), height: 8)
                }
            }
            .frame(height: 8)

            HStack {
                Text("\(budget.spentPercentage.formatted(.number.precision(.fractionLength(0))))% \(String(localized: "used"))")
                    .font(.caption)
                    .foregroundStyle(progressColor)
                Spacer()
                Text("\(budget.remainingAmount.formatted(.number.precision(.fractionLength(2)))) \(budget.currency) \(String(localized: "remaining"))")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .padding(.vertical, 4)
    }
}
