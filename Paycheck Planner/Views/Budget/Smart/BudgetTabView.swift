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
        VStack {
            if let workingBudget {
                BudgetView(
                    budget: workingBudget,
                    categories: categories,
                    onAddBudgetItem: createNewBudgetItem,
                    showBudgetSelectionSheet: $showBudgetSelectionSheet
                )
            } else {
                NoBudgetsView(showAddBudgetAlert: $showAddBudgetAlert, showBudgetSelectionSheet: $showBudgetSelectionSheet)
            }
        }
        .sheet(isPresented: $showBudgetSelectionSheet) {
            BudgetSelectionView(budgets: budgets, showAddBudgetAlert: $showAddBudgetAlert, onSetBudget: setBudget)
        }
        .alert("New Budget", isPresented: $showAddBudgetAlert, actions: {
            NewBudgetDialogView(onSetBudget: setBudget, onCreateNewBudget: createNewBudget, showAddBudgetAlert: $showAddBudgetAlert)
        })
    }
    
    private func deleteBudgetItem(at offsets: IndexSet, in category: ExpenseCategory, for budget: Budget) {
        let itemsForCategory = budget.items.filter { $0.category == category }
        for index in offsets {
            let itemToDelete = itemsForCategory[index]
            modelContext.delete(itemToDelete)
        }
    }
    
    private func createNewBudget(name: String) -> Budget {
        let newBudget = Budget(name: name)
        modelContext.insert(newBudget)
        showAddBudgetAlert = false
        return newBudget
    }
    
    private func setBudget(budget: Budget) {
        appState.workingBudgetID = budget.id
        showBudgetSelectionSheet = false
    }
    
    private func createNewBudgetItem(_ name: String, for budget: Budget, in category: ExpenseCategory, amount: Double, frequency: BudgetItem.BudgetFrequency) {
        let newBudgetItem = BudgetItem(name: name, amount: amount, category: category, frequency: frequency)
        
        newBudgetItem.budget = budget
        modelContext.insert(newBudgetItem)
    }
}
