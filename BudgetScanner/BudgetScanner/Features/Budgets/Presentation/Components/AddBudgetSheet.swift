//
//  AddBudgetSheet.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Budgets/Presentation/Components/AddBudgetSheet.swift
import SwiftUI

struct AddBudgetSheet: View {
    @Environment(BudgetsViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    var budgetToEdit: BudgetEntity? = nil

    @State private var name = ""
    @State private var category = ""
    @State private var limitText = ""
    @State private var color = "#10B981"
    @State private var currency = "EUR"
    @State private var isRecurring = false
    @State private var alertThreshold = 80
    @State private var isSaving = false
    @State private var errorMessage: String?

    private let currencies = ["EUR", "USD", "GBP"]
    private let colorOptions = ["#10B981", "#3B82F6", "#8B5CF6", "#F59E0B", "#EF4444", "#EC4899", "#14B8A6"]

    private var isEditing: Bool { budgetToEdit != nil }
    private var limit: Double { Double(limitText) ?? 0 }

    var body: some View {
        NavigationStack {
            Form {
                Section(String(localized: "budget_details")) {
                    TextField(String(localized: "budget_name"), text: $name)
                    TextField(String(localized: "category"), text: $category)
                    TextField(String(localized: "limit"), text: $limitText)
                        .keyboardType(.decimalPad)
                }

                Section(String(localized: "currency")) {
                    Picker(String(localized: "currency"), selection: $currency) {
                        ForEach(currencies, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)
                }

                Section(String(localized: "color")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(colorOptions, id: \.self) { option in
                                Circle()
                                    .fill(Color(hex: option))
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: color == option ? 3 : 0)
                                    )
                                    .onTapGesture { color = option }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section(String(localized: "settings")) {
                    Toggle(String(localized: "recurring_monthly"), isOn: $isRecurring)
                    Stepper(
                        String(localized: "alert_at \(alertThreshold)%"),
                        value: $alertThreshold,
                        in: 10...100,
                        step: 10
                    )
                }
            }
            .navigationTitle(isEditing ? String(localized: "edit_budget") : String(localized: "add_budget"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "save")) {
                        Task { await save() }
                    }
                    .disabled(name.isEmpty || category.isEmpty || limit <= 0 || isSaving)
                }
            }
            .alert(String(localized: "error"), isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button(String(localized: "OK"), role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
            .onAppear { populateIfEditing() }
        }
    }

    /// Guarda y cierra la hoja solo si salió bien. Si falla, la hoja sigue abierta con lo escrito
    /// y se avisa con una alerta.
    private func save() async {
        isSaving = true
        defer { isSaving = false }

        let message: String?
        if isEditing, let budget = budgetToEdit {
            message = await viewModel.editBudget(
                id: budget.id, name: name, category: category,
                limit: limit, color: color, currency: currency,
                isRecurring: isRecurring, alertThreshold: alertThreshold
            )
        } else {
            message = await viewModel.addBudget(
                name: name, category: category, limit: limit,
                color: color, currency: currency,
                isRecurring: isRecurring, alertThreshold: alertThreshold
            )
        }

        if let message {
            errorMessage = message
        } else {
            dismiss()
        }
    }

    private func populateIfEditing() {
        guard let budget = budgetToEdit else { return }
        name           = budget.name
        category       = budget.category
        limitText      = String(budget.limit)
        color          = budget.color
        currency       = budget.currency
        isRecurring    = budget.isRecurring
        alertThreshold = budget.alertThreshold
    }
}
