//
//  ContentView.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/ContentView.swift
import SwiftUI

struct ContentView: View {
    @State private var viewModel = AuthViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .tint(Color.emerald)
            } else if viewModel.isAuthenticated {
                MainTabView()
                    .environment(viewModel)
            } else {
                LoginView()
                    .environment(viewModel)
            }
        }
        .animation(.easeInOut, value: viewModel.isAuthenticated)
    }
}
