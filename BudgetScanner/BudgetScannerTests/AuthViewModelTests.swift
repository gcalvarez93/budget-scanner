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

    // MARK: - Sesión inicial

    @Test func startsAuthenticatedWhenThereIsASession() {
        repository.signedInUser = TestData.user

        let viewModel = makeViewModel()

        #expect(viewModel.state == .authenticated(TestData.user))
        #expect(viewModel.isAuthenticated)
        #expect(!viewModel.isLoading)
    }

    @Test func startsUnauthenticatedWithoutSession() {
        let viewModel = makeViewModel()

        #expect(viewModel.state == .unauthenticated)
        #expect(!viewModel.isAuthenticated)
        #expect(!viewModel.isLoading)
    }

    // MARK: - Inicio de sesión

    @Test func successfulLoginLeavesTheUserAuthenticated() async {
        let viewModel = makeViewModel()

        await viewModel.signInWithEmail(email: "ana@test.com", password: "123456")

        #expect(viewModel.state == .authenticated(TestData.user))
    }

    @Test func failedLoginExposesTheUserMessage() async {
        repository.loginResult = .failure(.invalidCredentials)
        let viewModel = makeViewModel()

        await viewModel.signInWithEmail(email: "ana@test.com", password: "bad")

        #expect(viewModel.state == .error(Failure.invalidCredentials.userMessage))
        #expect(viewModel.errorMessage == Failure.invalidCredentials.userMessage)
    }

    @Test func technicalDetailOfAuthFailuresDoesNotReachTheUser() async {
        repository.loginResult = .failure(.auth("Wrong password"))
        let viewModel = makeViewModel()

        await viewModel.signInWithEmail(email: "ana@test.com", password: "bad")

        #expect(viewModel.errorMessage == Failure.auth("Wrong password").userMessage)
        #expect(viewModel.errorMessage?.contains("Wrong password") == false)
    }

    // MARK: - Registro

    @Test func failedRegistrationExposesTheUserMessage() async {
        repository.loginResult = .failure(.emailAlreadyInUse)
        let viewModel = makeViewModel()

        await viewModel.signUpWithEmail(email: "ana@test.com", password: "123456", name: "Ana")

        #expect(viewModel.errorMessage == Failure.emailAlreadyInUse.userMessage)
    }

    // MARK: - Google

    @Test func cancellingGoogleSignInLeavesTheUserUnauthenticatedWithoutAnError() async {
        repository.googleError = CancellationError()
        let viewModel = makeViewModel()

        await viewModel.signInWithGoogle()

        #expect(viewModel.state == .unauthenticated)
        #expect(viewModel.errorMessage == nil)
    }

    // MARK: - Cerrar sesión

    @Test func signOutLeavesTheUserUnauthenticated() async {
        repository.signedInUser = TestData.user
        let viewModel = makeViewModel()

        let message = await viewModel.signOut()

        #expect(message == nil)
        #expect(viewModel.state == .unauthenticated)
    }

    @Test func failedSignOutKeepsTheSessionAndReturnsTheUserMessage() async {
        repository.signedInUser = TestData.user
        repository.logoutResult = .failure(.auth("Sign out failed"))
        let viewModel = makeViewModel()

        let message = await viewModel.signOut()

        #expect(message == Failure.auth("Sign out failed").userMessage)
        #expect(viewModel.state == .authenticated(TestData.user))
        #expect(viewModel.isAuthenticated)
    }
}
