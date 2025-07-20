//
//  BudgetManagerView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/11/25.
//

import SwiftUI
import SwiftData

struct IncomeSelectionView: View {
    @Query var incomes: [Income]
    
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    
    @State private var showAddBudgetAlert = false
    @State private var newBudgetName = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Select an Income")
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
            List(incomes) { income in
                Button{
                    
                } label: {
                    Text(income.name)
                }
            }
        }
        .alert("New Income", isPresented: $showAddBudgetAlert, actions: {
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
    let container = try! ModelContainer(for: Income.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    return IncomeSelectionView()
        .environment(previewAppState)
        .modelContext(context)
}
