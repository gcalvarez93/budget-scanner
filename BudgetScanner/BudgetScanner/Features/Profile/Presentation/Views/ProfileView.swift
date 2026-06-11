//
//  ProfileView.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Profile/Presentation/Views/ProfileView.swift
import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @Environment(ThemeManager.self) private var themeManager

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .initial, .loading:
                    ProgressView().tint(Color.emerald)
                case .loaded(let profile):
                    profileContent(profile)
                case .error(let message):
                    ContentUnavailableView(
                        String(localized: "error"),
                        systemImage: "exclamationmark.triangle",
                        description: Text(message)
                    )
                }
            }
            .navigationTitle(String(localized: "nav_profile"))
            .task { await viewModel.loadProfile() }
        }
        .environment(viewModel)
    }

    @ViewBuilder
    private func profileContent(_ profile: ProfileEntity) -> some View {
        List {
            // Avatar header
            Section {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.emerald.opacity(0.2))
                            .frame(width: 64, height: 64)
                        Text(profile.name.prefix(1).uppercased())
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.emerald)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text(profile.name)
                            .font(.headline)
                            .foregroundStyle(Color.primary)
                        Text(profile.email)
                            .font(.subheadline)
                            .foregroundStyle(Color.secondary)
                    }
                }
                .padding(.vertical, 8)
            }

            // Ajustes
            Section(String(localized: "settings")) {
                Button {
                    viewModel.showEditProfile = true
                } label: {
                    Label(String(localized: "edit_profile"), systemImage: "person.fill")
                        .foregroundStyle(Color.primary)
                }

                Button {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        Label(String(localized: "language"), systemImage: "globe")
                            .foregroundStyle(Color.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                    }
                }

                HStack {
                    Label(String(localized: "notifications"), systemImage: "bell.fill")
                        .foregroundStyle(Color.primary)
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { profile.notifications },
                        set: { newValue in
                            Task {
                                await viewModel.update(
                                    name: profile.name,
                                    language: profile.language,
                                    notifications: newValue
                                )
                            }
                        }
                    ))
                    .tint(Color.emerald)
                }

                HStack {
                    Label(String(localized: "appearance"), systemImage: "moon.fill")
                        .foregroundStyle(Color.primary)
                    Spacer()
                    Picker("", selection: Binding(
                        get: { themeManager.colorSchemeString },
                        set: { themeManager.setScheme($0) }
                    )) {
                        Text(String(localized: "system")).tag("system")
                        Text(String(localized: "light")).tag("light")
                        Text(String(localized: "dark")).tag("dark")
                    }
                    .pickerStyle(.menu)
                }
            }

            Section {
                Button(role: .destructive) {
                    Task {
                        let repo = AuthRepository()
                        try? await repo.logout()
                    }
                } label: {
                    Label(String(localized: "sign_out"), systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .sheet(isPresented: Binding(
            get: { viewModel.showEditProfile },
            set: { viewModel.showEditProfile = $0 }
        )) {
            EditProfileSheet(profile: profile)
                .environment(viewModel)
        }
    }
}
