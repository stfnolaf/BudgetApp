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
    let onSetBudget: ((Budget) -> Void)

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
                    onSetBudget(budget)
                    dismiss()
                } label: {
                    Text(budget.name)
                }
            }
        }
    }
}
