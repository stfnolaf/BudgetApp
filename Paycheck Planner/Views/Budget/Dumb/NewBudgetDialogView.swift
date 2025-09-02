//
//  NewBudgetDialogView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 9/2/25.
//

import SwiftUI

struct NewBudgetDialogView: View {
    let onSetBudget: (Budget) -> Void
    let onCreateNewBudget: (String) -> Budget
    @Binding var showAddBudgetAlert: Bool
    
    @State var newBudgetName: String = ""
    var body: some View {
        TextField("Budget Name", text: $newBudgetName)
        Button("Create", action: {
            onSetBudget(onCreateNewBudget(newBudgetName))
            newBudgetName = ""
            showAddBudgetAlert = false
        })
        Button("Cancel", role: .cancel, action: {
            newBudgetName = ""
            showAddBudgetAlert = false
        })
    }
}

#Preview {
    @Previewable @State var showAddBudgetAlert: Bool = true
    NewBudgetDialogView(onSetBudget: { budget in }, onCreateNewBudget: { title in Budget(name: title) }, showAddBudgetAlert: $showAddBudgetAlert)
}
