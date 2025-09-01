//
//  BudgetManagerView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/11/25.
//

import SwiftUI
import SwiftData

struct BudgetSelectionView: View {
    let budgets: [Budget]
    @Binding var showAddBudgetAlert: Bool
    let onCreateNewBudget: ((String) -> Void)

    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
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
                    appState.workingBudgetID = budget.id
                    dismiss()
                } label: {
                    Text(budget.name)
                }
            }
        }
        .alert("New Budget", isPresented: $showAddBudgetAlert, actions: {
            TextField("List Name", text: $newBudgetName)
            Button("Create", action: {
                onCreateNewBudget(newBudgetName)
                newBudgetName = ""
                showAddBudgetAlert = false
            })
            Button("Cancel", role: .cancel, action: {
                newBudgetName = ""
                showAddBudgetAlert = false
            })
        })
    }
}
