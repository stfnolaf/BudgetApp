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
    // Inputs
    @Binding var workingBudget: Budget?
    
    // SwiftData
    @Query var categories: [ExpenseCategory]
    @Query var budgets: [Budget]
    
    // Environment
    @Environment(\.modelContext) private var modelContext
    
    // States
    @State private var showBudgetSelectionSheet = false

    var body: some View {
        // It contains the logic to decide which view to show.
        if let budget = workingBudget {
            // header
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Text(budget.name)
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
                    budget: budget,
                    categories: categories
                )
            }
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
    
    private func deleteBudgetItem(at offsets: IndexSet, in category: ExpenseCategory, for budget: Budget) {
        let itemsForCategory = budget.items.filter { $0.category == category }
        for index in offsets {
            let itemToDelete = itemsForCategory[index]
            modelContext.delete(itemToDelete)
        }
    }
}

#Preview {
    @Previewable @State var workingBudget: Budget? = Budget.forPreview
    BudgetTabView(workingBudget: $workingBudget)
        .modelContainer(ModelContainer.forPreview)
}
