//
//  ContentView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(AppState.self) private var appState
    
    @Query(sort: \Budget.name) private var budgets: [Budget]
                
    enum Tab: Hashable {
        case overview, budget, track, grow, income
    }
    
    @State private var selectedTab: Tab = .overview
    
    var body: some View {
        @Bindable var appState = appState
        TabView(selection: $selectedTab) {
            OverviewView()
                .tabItem { Label("Overview", systemImage: "chart.pie") }
                .tag(Tab.overview)
            BudgetTabView(workingBudget: $appState.workingBudget)
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
        .task {
            loadWorkingBudget()
        }
    }
    
    func loadWorkingBudget() {
        guard appState.workingBudget == nil, !budgets.isEmpty else { return }
        
        if let savedID = AppDefaults.loadWorkingBudgetID() {
            appState.workingBudget = budgets.first(where: { $0.id == savedID })
        }
        
        if appState.workingBudget == nil {
            appState.workingBudget = budgets.first
        }
    }
}

#Preview {
    return ContentView()
        .modelContainer(.forPreview)
}
