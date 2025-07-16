//
//  ContentView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var viewModel: ViewModel
    
    enum Tab: Hashable {
        case overview, spend, save, invest, settings
    }
    
    @State private var selectedTab: Tab = .overview
    
    var body: some View {
        TabView {
            OverviewView()
                .tabItem { Label("Overview", systemImage: "house") }
            BudgetView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem { Label("Budget", systemImage: "list.bullet.rectangle") }
            ExpenseView()
                .tabItem { Label("Track", systemImage: "creditcard") }
            GrowView()
                .tabItem { Label("Grow", systemImage: "chart.bar") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
    }
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    let container = try! ModelContainer(for: Expense.self, Budget.self, Income.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = container.mainContext
    return ContentView(modelContext: context)
}
