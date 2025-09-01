//
//  ContentView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("didSetupDefaults") private var didSetupDefaults: Bool = false

    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Budget.name) private var budgets: [Budget]
                
    enum Tab: Hashable {
        case overview, budget, track, grow, income
    }
    
    @State private var selectedTab: Tab = .overview
    
    var body: some View {
        TabView(selection: $selectedTab) {
            OverviewView()
                .tabItem { Label("Overview", systemImage: "chart.pie") }
                .tag(Tab.overview)
            BudgetTabView()
                .tabItem { Label("Budget", systemImage: "list.bullet.rectangle") }
                .tag(Tab.budget)
            ExpenseTrackingView()
                .tabItem { Label("Track", systemImage: "creditcard") }
                .tag(Tab.track)
            GrowView()
                .tabItem { Label("Grow", systemImage: "chart.bar") }
                .tag(Tab.grow)
            IncomeView()
                .tabItem { Label("Income", systemImage: "dollarsign.circle") }
                .tag(Tab.income)
        }
        .onAppear(perform: setupDefaults)
        .onAppear(perform: loadWorkingBudget)
    }
    
    private func loadWorkingBudget() {
        guard !budgets.isEmpty else {return}
        
        let isInvalidID = appState.workingBudgetID == nil || !budgets.contains(where: { $0.id == appState.workingBudgetID! })
        
        if isInvalidID {
            appState.workingBudgetID = budgets.first?.id
        }
    }
    
    private func setupDefaults() {
        if !didSetupDefaults {
            let rent = ExpenseCategory(name: "Rent")
            let utilities = ExpenseCategory(name: "Utilities")
            let transport = ExpenseCategory(name: "Transport")
            let groceries = ExpenseCategory(name: "Groceries")
            let splurge = ExpenseCategory(name: "Splurge")
            
            modelContext.insert(rent)
            modelContext.insert(utilities)
            modelContext.insert(transport)
            modelContext.insert(groceries)
            modelContext.insert(splurge)
            didSetupDefaults = true
        }
    }
}

#Preview {
    return ContentView()
        .modelContainer(.forPreview)
}
