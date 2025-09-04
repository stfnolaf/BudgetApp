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
    @State private var showAddBudgetAlert: Bool = false {
        didSet {
            let _ = print ("Show Add Budget Alert: \(showAddBudgetAlert)")
        }
    }
    
    // Computed
    private var workingBudget: Budget? {
        let _ = print("Looking for \(String(describing: appState.workingBudgetID)) across \(budgets.count) budgets")
        let ret = budgets.first {$0.id == appState.workingBudgetID}
        let _ = print("Returning \(ret?.name ?? "Unknown")")
        return ret
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
                VStack {
                    Spacer()
                    Text("No budgets created yet!")
                    Button(action: {
                        showAddBudgetAlert = true
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
            BudgetSelectionView(budgets: budgets, showAddBudgetAlert: $showAddBudgetAlert, onSetBudget: setBudget)
        }
        // TODO: need to not do this via an alert
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
        do {
            try modelContext.save()
        } catch {
            // TODO: alert popup
            print("Failed to save the new budget: \(error)")
        }
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
        do {
            try modelContext.save()
        } catch {
            // TODO: alert popup
            print("Failed to save the new budget item: \(error)")
        }
    }
}
