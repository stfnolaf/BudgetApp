//
//  ContentView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var budgets: [Budget]
    @Query var profiles: [Profile]
    
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) var appState
        
    private static let lastWorkingBudgetIDKey = "lastWorkingBudgetID"
    private static let lastWorkingIncomeIDKey = "lastWorkingIncomeID"
        
    enum Tab: Hashable {
        case overview, budget, track, grow, income
    }
    
    @State private var selectedTab: Tab = .overview
    
    var body: some View {
        TabView(selection: $selectedTab) {
            OverviewView()
                .tabItem { Label("Overview", systemImage: "chart.pie") }
                .tag(Tab.overview)
            BudgetView(selectedTab: $selectedTab)
                .tabItem { Label("Budget", systemImage: "list.bullet.rectangle") }
                .tag(Tab.budget)
            ExpenseView()
                .tabItem { Label("Track", systemImage: "creditcard") }
                .tag(Tab.track)
            GrowView()
                .tabItem { Label("Grow", systemImage: "chart.bar") }
                .tag(Tab.grow)
            IncomeView(selectedTab: $selectedTab)
                .tabItem { Label("Income", systemImage: "dollarsign.circle") }
                .tag(Tab.income)
        }
        .onAppear() {
            fetchLastWorkingBudget()
            if(profiles.isEmpty) {
                let newProfile = Profile()
                modelContext.insert(newProfile)
            }
            appState.userProfile = profiles.first
        }
        .onChange(of: appState.workingBudget) {
            if let newID = appState.workingBudget?.id {
                UserDefaults.standard.set(newID.uuidString, forKey: Self.lastWorkingBudgetIDKey)
            } else {
                UserDefaults.standard.removeObject(forKey: Self.lastWorkingBudgetIDKey)
            }
        }
    }

    private func fetchLastWorkingBudget() {
        let savedID = UserDefaults.standard.string(forKey: Self.lastWorkingBudgetIDKey)
        let matched = budgets.first(where: { $0.id.uuidString == savedID })
        if let matchedBudget = matched {
            appState.workingBudget = matchedBudget
        } else {
            appState.workingBudget = budgets.first
        }
    }
}

#Preview {
    let rent = Expense(category: "Rent", amount: 3500, title: "Rent", frequency: .monthly)
    let groceries = Expense(category: "Groceries", amount: 300, title: "Food", frequency: .monthly)
    let internet = Expense(category: "Utilities", amount: 80, title: "Internet", frequency: .monthly)
    let previewAppState = AppState()
    let budget = Budget("My Budget", expenses: [rent, groceries, internet])
    let container = try! ModelContainer(for: Budget.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    context.insert(budget)
    previewAppState.workingBudget = budget
    return ContentView()
        .environment(previewAppState)
        .modelContext(context)
}
