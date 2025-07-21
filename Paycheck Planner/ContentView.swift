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
    @Query var incomes: [Income]
    
    @Environment(AppState.self) var appState
        
    private static let lastWorkingBudgetIDKey = "lastWorkingBudgetID"
        
    enum Tab: Hashable {
        case overview, budget, track, grow, profile
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
            PaycheckView(selectedTab: $selectedTab)
                .tabItem { Label("Paycheck", systemImage: "dollarsign.circle") }
                .tag(Tab.profile)
        }
        .onAppear() {
            fetchLastWorkingBudget()
            fetchLastWorkingIncome()
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
    
    private func fetchLastWorkingIncome() {
        
    }
}

#Preview {
    var rent = Expense(category: "Rent", amount: 3500, title: "Rent", frequency: .monthly)
    var groceries = Expense(category: "Groceries", amount: 300, title: "Food", frequency: .monthly)
    var internet = Expense(category: "Utilities", amount: 80, title: "Internet", frequency: .monthly)
    let previewAppState = AppState()
    var budget = Budget("My Budget", expenses: [rent, groceries, internet])
    var income = Income("My Income", annualGrossIncome: 164390, pctContribPreTax401k: 0.06, pctEmployerMatch401k: 0.75, pctEmployerMatchMax401k: 0.06, dollarContribHSA: 4300, dollarEmployerContribHSA: 600, pctContribESPP: 0.05, pctESPPDiscount: 0.15)
    let container = try! ModelContainer(for: Budget.self, Income.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    context.insert(budget)
    context.insert(income)
    previewAppState.workingBudget = budget
    previewAppState.workingIncome = income
    return ContentView()
        .environment(previewAppState)
        .modelContext(context)
}
