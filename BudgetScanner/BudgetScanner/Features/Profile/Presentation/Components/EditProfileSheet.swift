//
//  EditProfileSheet.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Profile/Presentation/Components/EditProfileSheet.swift
import SwiftUI

struct EditProfileSheet: View {
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    let profile: ProfileEntity

    @State private var name = ""
    @State private var isSaving = false
    @State private var showError = false

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(String(localized: "profile_info")) {
                    TextField(String(localized: "name"), text: $name)
                }
            }
            .navigationTitle(String(localized: "edit_profile"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "save")) {
                        Task { await save() }
                    }
                    .disabled(trimmedName.isEmpty || isSaving)
                }
            }
            .alert(String(localized: "error"), isPresented: $showError) {
                Button(String(localized: "OK"), role: .cancel) {}
            } message: {
                Text(String(localized: "profile_update_error"))
            }
            .onAppear { name = profile.name }
        }
    }

    private func save() async {
        isSaving = true
        defer { isSaving = false }

        let saved = await viewModel.update(
            name: trimmedName,
            language: profile.language,
            notifications: profile.notifications
        )
        if saved {
            dismiss()
        } else {
            showError = true
        }
    }
}
