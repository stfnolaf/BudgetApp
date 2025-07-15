//
//  BudgetManagerView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/11/25.
//

import SwiftUI

struct BudgetSelectionView: View {
    let budgets: [Budget]
    let onSelect: (Budget) -> Void
    let onAddBudget: (Budget) -> Void
    
    @State private var showAddBudgetAlert = false
    @State private var newBudgetName = ""
    
    var body: some View {
        NavigationView {
            List(budgets) { budget in
                Button(action: { onSelect(budget) }) {
                    Text(budget.name)
                }
            }
            .navigationTitle("Select a Budget")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddBudgetAlert = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("New Expense List", isPresented: $showAddBudgetAlert, actions: {
                TextField("List Name", text: $newBudgetName)
                Button("Create", action: {
                    let newBudget = Budget(newBudgetName)
                    onAddBudget(newBudget)
                    newBudgetName = ""
                    showAddBudgetAlert = false
                    onSelect(newBudget)
                })
                Button("Cancel", role: .cancel, action: {
                    newBudgetName = ""
                    showAddBudgetAlert = false
                })
            })
        }
    }
}
