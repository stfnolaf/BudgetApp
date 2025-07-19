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
    
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    
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
            .padding([.top, .horizontal])
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
                let newBudget = Budget(newBudgetName)
                modelContext.insert(newBudget)
                newBudgetName = ""
                showAddBudgetAlert = false
                appState.workingBudget = newBudget
            })
            Button("Cancel", role: .cancel, action: {
                newBudgetName = ""
                showAddBudgetAlert = false
            })
        })
    }
}

#Preview {
    let previewAppState = AppState()
    let container = try! ModelContainer(for: Budget.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    return BudgetSelectionView()
        .environment(previewAppState)
        .modelContext(context)
}
