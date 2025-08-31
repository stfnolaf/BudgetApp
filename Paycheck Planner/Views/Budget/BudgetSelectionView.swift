//
//  BudgetManagerView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/11/25.
//

import SwiftUI
import SwiftData

struct BudgetSelectionView: View {
    @Query var budgets: [Budget]
    
    @Environment(\.workingBudget) private var workingBudget
    @Environment(\.modelContext) private var modelContext
    
    @State private var showAddBudgetAlert = false
    @State private var newBudgetName = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Select a Budget")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button {
                    showAddBudgetAlert = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .padding()
            List(budgets) { budget in
                Button{
                    
                } label: {
                    Text(budget.name)
                }
            }
        }
        .alert("New Budget", isPresented: $showAddBudgetAlert, actions: {
            TextField("List Name", text: $newBudgetName)
            Button("Create", action: {
                let newBudget = Budget(name: newBudgetName)
                modelContext.insert(newBudget)
                newBudgetName = ""
                showAddBudgetAlert = false
                workingBudget.wrappedValue = newBudget
            })
            Button("Cancel", role: .cancel, action: {
                newBudgetName = ""
                showAddBudgetAlert = false
            })
        })
    }
}

#Preview {
    return BudgetSelectionView()
        .modelContainer(.forPreview)
}
