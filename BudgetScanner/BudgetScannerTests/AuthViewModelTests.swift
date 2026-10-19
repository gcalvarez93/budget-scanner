// Path: BudgetScanner/BudgetScannerTests/AuthViewModelTests.swift
import Testing
@testable import BudgetScanner

@MainActor
struct AuthViewModelTests {
    private let repository = FakeAuthRepository()

    private func makeViewModel() -> AuthViewModel {
        AuthViewModel(
            loginWithEmail: LoginWithEmailUseCase(repository: repository),
            registerWithEmail: RegisterWithEmailUseCase(repository: repository),
            loginWithGoogle: LoginWithGoogleUseCase(repository: repository),
            logout: LogoutUseCase(repository: repository),
            repository: repository
        )
    }

    @Test func startsAuthenticatedWhenThereIsASession() {
        repository.signedInUser = TestData.user

        let viewModel = makeViewModel()

        #expect(viewModel.state == .authenticated(TestData.user))
        #expect(viewModel.isAuthenticated)
    }

    @Test func startsUnauthenticatedWithoutSession() {
        let viewModel = makeViewModel()

        #expect(viewModel.state == .unauthenticated)
        #expect(!viewModel.isAuthenticated)
    }

    @Test func successfulLoginLeavesTheUserAuthenticated() async {
        let viewModel = makeViewModel()

        await viewModel.signInWithEmail(email: "ana@test.com", password: "123456")

        #expect(viewModel.state == .authenticated(TestData.user))
    }

    @Test func failedLoginExposesTheAuthMessage() async {
        repository.loginResult = .failure(.auth("Wrong password"))
        let viewModel = makeViewModel()

        await viewModel.signInWithEmail(email: "ana@test.com", password: "bad")

        #expect(viewModel.state == .error("Auth error: Wrong password"))
        #expect(viewModel.errorMessage == "Auth error: Wrong password")
    }

    @Test func signOutLeavesTheUserUnauthenticated() async {
        repository.signedInUser = TestData.user
        let viewModel = makeViewModel()

        await viewModel.signOut()

        #expect(viewModel.state == .unauthenticated)
    }

    @Test func failedSignOutShowsTheMessage() async {
        repository.signedInUser = TestData.user
        repository.logoutResult = .failure(.auth("Sign out failed"))
        let viewModel = makeViewModel()

        await viewModel.signOut()

        #expect(viewModel.state == .error("Auth error: Sign out failed"))
    }
}
