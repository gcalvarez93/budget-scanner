//
//  LoginView.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Auth/Presentation/Views/LoginView.swift
import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) private var viewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 40)

                    // Logo
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(Color.emerald)

                    Text(String(localized: "app_name"))
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(String(localized: "login_subtitle"))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer().frame(height: 16)

                    VStack(spacing: 16) {
                        AuthTextField(
                            title: String(localized: "email"),
                            text: $email,
                            keyboardType: .emailAddress
                        )
                        AuthTextField(
                            title: String(localized: "password"),
                            text: $password,
                            isSecure: true
                        )
                    }

                    Button {
                        Task { await viewModel.signInWithEmail(email: email, password: password) }
                    } label: {
                        Group {
                            if case .loading = viewModel.state {
                                ProgressView().tint(.white)
                            } else {
                                Text(String(localized: "sign_in"))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.emerald)
                        .cornerRadius(12)
                    }
                    .disabled(email.isEmpty || password.isEmpty)

                    HStack {
                        Rectangle().frame(height: 1).foregroundStyle(Color(.systemGray4))
                        Text(String(localized: "or")).foregroundStyle(.secondary).padding(.horizontal, 8)
                        Rectangle().frame(height: 1).foregroundStyle(Color(.systemGray4))
                    }

                    GoogleSignInButton {
                        Task { await viewModel.signInWithGoogle() }
                    }

                    HStack {
                        Text(String(localized: "no_account"))
                            .foregroundStyle(.secondary)
                        Button(String(localized: "register")) {
                            showRegister = true
                        }
                        .foregroundStyle(Color.emerald)
                    }
                    .font(.subheadline)
                }
                .padding(.horizontal, 24)
            }
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
                    .environment(viewModel)
            }
            .onChange(of: viewModel.state) { _, newState in
                if case .error(let message) = newState {
                    errorMessage = message
                    showError = true
                }
            }
            .alert(String(localized: "error"), isPresented: $showError) {
                Button("OK") { showError = false }
            } message: {
                Text(errorMessage)
            }
        }
    }
}
