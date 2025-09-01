//
//  BudgetContainerView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 8/31/25.
//

import SwiftUI
import SwiftData

// This should handle all functionality regarding modifying appState.workingBudget ("smart").
// All child views should be "dumb" and have no functionality.
struct BudgetTabView: View {
    // SwiftData
    @Query var categories: [ExpenseCategory]
    @Query var budgets: [Budget]
    
    // Environment
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    
    // States
    @State private var showBudgetSelectionSheet = false
    @State private var showAddBudgetAlert: Bool = false
    
    // Computed
    private var workingBudget: Budget? {
        budgets.first {$0.id == appState.workingBudgetID}
    }

    var body: some View {
        Group {
            // It contains the logic to decide which view to show.
            if let workingBudget {
                // header
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        Text(workingBudget.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: {
                            showBudgetSelectionSheet = true
                        }) {
                            Image(systemName: "list.bullet")
                        }
                    }
                    .padding()
                    // category view list
                    BudgetView(
                        budget: workingBudget,
                        categories: categories,
                        onAddBudgetItem: createNewBudgetItem
                    )
                }
            } else {
                // It handles the "no budget" case.
                VStack {
                    Spacer()
                    Text("No budgets created yet!")
                    Button(action: {
                        showAddBudgetAlert = true
                        showBudgetSelectionSheet = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("New Budget")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor.opacity(0.15))
                        .cornerRadius(12)
                    }
                    .padding()
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showBudgetSelectionSheet) {
            BudgetSelectionView(budgets: budgets, showAddBudgetAlert: $showAddBudgetAlert, onCreateNewBudget: createAndSetNewBudget)
        }
    }
    
    private func deleteBudgetItem(at offsets: IndexSet, in category: ExpenseCategory, for budget: Budget) {
        let itemsForCategory = budget.items.filter { $0.category == category }
        for index in offsets {
            let itemToDelete = itemsForCategory[index]
            modelContext.delete(itemToDelete)
        }
    }
    
    private func createAndSetNewBudget(name: String) {
        let newBudget = Budget(name: name)
        modelContext.insert(newBudget)
        appState.workingBudgetID = newBudget.id
        showBudgetSelectionSheet = false
        showAddBudgetAlert = false
    }
    
    private func createNewBudgetItem(_ name: String, for budget: Budget, in category: ExpenseCategory, amount: Double, frequency: BudgetItem.BudgetFrequency) {
        let newBudgetItem = BudgetItem(name: name, amount: amount, category: category, frequency: frequency)
        
        newBudgetItem.budget = budget
        modelContext.insert(newBudgetItem)
    }
}

#Preview {
    ({
        let container = ModelContainer.forPreview
        let appState = AppState()
        let firstBudget = try! container.mainContext.fetch(FetchDescriptor<Budget>()).first
        appState.workingBudgetID = firstBudget?.id
        return BudgetTabView()
            .environment(appState)
            .modelContainer(container)
    })()
}
