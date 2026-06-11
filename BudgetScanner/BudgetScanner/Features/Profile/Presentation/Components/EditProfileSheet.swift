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
                        Task {
                            await viewModel.update(
                                name: name,
                                language: profile.language,
                                notifications: profile.notifications
                            )
                            dismiss()
                        }
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onAppear { name = profile.name }
        }
    }
}
