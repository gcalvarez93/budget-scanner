//
//  AddTransactionSheet.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Transactions/Presentation/Components/AddTransactionSheet.swift
import SwiftUI

struct AddTransactionSheet: View {
    @Environment(TransactionsViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    var transactionToEdit: TransactionEntity? = nil

    @State private var description = ""
    @State private var category = ""
    @State private var amountText = ""
    @State private var currency = "EUR"
    @State private var notes = ""
    @State private var merchant = ""
    @State private var date = Date()
    @State private var tagsText = ""

    private let currencies = ["EUR", "USD", "GBP"]
    private var isEditing: Bool { transactionToEdit != nil }
    private var amount: Double { Double(amountText) ?? 0 }
    private var tags: [String] {
        tagsText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(String(localized: "transaction_details")) {
                    TextField(String(localized: "description"), text: $description)
                    TextField(String(localized: "category"), text: $category)
                    TextField(String(localized: "merchant_optional"), text: $merchant)
                    TextField(String(localized: "amount"), text: $amountText)
                        .keyboardType(.decimalPad)
                    DatePicker(String(localized: "date"), selection: $date, displayedComponents: .date)
                }

                Section(String(localized: "currency")) {
                    Picker(String(localized: "currency"), selection: $currency) {
                        ForEach(currencies, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)
                }

                Section(String(localized: "notes_tags")) {
                    TextField(String(localized: "notes_optional"), text: $notes, axis: .vertical)
                        .lineLimit(3)
                    TextField(String(localized: "tags_hint"), text: $tagsText)
                }
            }
            .navigationTitle(isEditing ? String(localized: "edit_transaction") : String(localized: "add_transaction"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "save")) {
                        Task {
                            if isEditing, let t = transactionToEdit {
                                await viewModel.editTransaction(
                                    id: t.id, category: category, amount: amount,
                                    currency: currency, description: description,
                                    notes: notes, tags: tags,
                                    receiptImageUrl: t.receiptImageUrl,
                                    merchant: merchant.isEmpty ? nil : merchant,
                                    date: date
                                )
                            } else {
                                await viewModel.addTransaction(
                                    category: category, amount: amount,
                                    currency: currency, description: description,
                                    notes: notes, tags: tags,
                                    receiptImageUrl: nil,
                                    merchant: merchant.isEmpty ? nil : merchant,
                                    date: date, isScanned: false
                                )
                            }
                            dismiss()
                        }
                    }
                    .disabled(description.isEmpty || category.isEmpty || amount <= 0)
                }
            }
            .onAppear { populateIfEditing() }
        }
    }

    private func populateIfEditing() {
        guard let t = transactionToEdit else { return }
        description = t.description
        category    = t.category
        amountText  = String(t.amount)
        currency    = t.currency
        notes       = t.notes
        merchant    = t.merchant ?? ""
        date        = t.date
        tagsText    = t.tags.joined(separator: ", ")
    }
}
