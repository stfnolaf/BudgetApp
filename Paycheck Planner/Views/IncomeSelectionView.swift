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
    @State private var newIncomeName = ""
    
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
            TextField("List Name", text: $newIncomeName)
            Button("Create", action: {
                let newIncome = Income(newIncomeName)
                modelContext.insert(newIncome)
                newIncomeName = ""
                showAddBudgetAlert = false
                appState.workingIncome = newIncome
            })
            Button("Cancel", role: .cancel, action: {
                newIncomeName = ""
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
