//
//  ContentView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var users: [User]
    
    private var user: User? {
        users.first
    }
    
    @State private var workingBudget: Budget?
    
    @Environment(\.modelContext) private var modelContext
        
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
            BudgetContainerView()
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
            setupInitialData()
        }
        .environment(\.workingBudget, $workingBudget)
        .environment(\.currentUser, user)
        .onChange(of: workingBudget) {
            if let newID = workingBudget?.persistentModelID {
                do {
                    let data = try JSONEncoder().encode(newID)
                    UserDefaults.standard.set(data, forKey: Self.lastWorkingBudgetIDKey)
                } catch {
                    print("Failed to save budget ID: \(error)")
                }
            } else {
                UserDefaults.standard.removeObject(forKey: Self.lastWorkingBudgetIDKey)
            }
        }
    }
    
    private func setupInitialData() {
        if users.isEmpty {
            modelContext.insert(User())
        }
        
        if let user = self.user {
            loadWorkingBudget(for: user)
        }
    }

    
    private func loadWorkingBudget(for user: User) {
        // 1. Primary Method: Try to load the specific budget from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "currentBudgetID") {
            do {
                let budgetID = try JSONDecoder().decode(PersistentIdentifier.self, from: data)
                // SwiftData is smart enough to find the model even without the user context
                if let budget = modelContext.model(for: budgetID) as? Budget {
                    self.workingBudget = budget
                    return // Success!
                }
            } catch {
                print("Failed to decode or find saved budget: \(error)")
            }
        }

        // 2. Fallback Method: Grab the first budget directly from the user's list
        self.workingBudget = user.budgets.first
    }
}

#Preview {
    return ContentView()
        .modelContainer(.forPreview)
}
