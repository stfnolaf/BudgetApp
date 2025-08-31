//
//  BudgetContainerView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 8/31/25.
//

import SwiftUI

struct BudgetContainerView: View {
    @Environment(\.currentUser) private var currentUser
    @Environment(\.workingBudget) private var workingBudget
    @Environment(\.modelContext) private var modelContext
    @State private var expandedCategories: Set<String> = []
    @State private var showBudgetSelectionSheet = false

    var body: some View {
        // It contains the logic to decide which view to show.
        if let user = currentUser, let budget = workingBudget.wrappedValue {
            // If a budget is selected, it passes the data down to the dumb view.
            BudgetView(
                user: user,
                budget: budget,
                expandedCategories: $expandedCategories,
                onSelectBudget: {
                    showBudgetSelectionSheet = true
                },
                onDeleteItem: { offsets, category in
                    deleteItem(at: offsets, in: category, for: budget)
                }
            )
            .sheet(isPresented: $showBudgetSelectionSheet) {
                BudgetSelectionView()
            }
        } else {
            // It handles the "no budget" case.
            VStack {
                Spacer()
                Text("No budgets created yet!")
                Button(action: {

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

    private func deleteItem(at offsets: IndexSet, in category: ExpenseCategory, for budget: Budget) {
        let itemsForCategory = budget.items.filter { $0.category == category }
        for index in offsets {
            let itemToDelete = itemsForCategory[index]
            modelContext.delete(itemToDelete)
        }
    }
}
