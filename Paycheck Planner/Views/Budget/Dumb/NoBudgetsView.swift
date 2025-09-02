//
//  NoBudgetsView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 9/2/25.
//

import SwiftUI

struct NoBudgetsView: View {
    @Binding var showAddBudgetAlert: Bool
    @Binding var showBudgetSelectionSheet: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text("No budgets created yet!")
            Button(action: {
                showAddBudgetAlert = true
                showBudgetSelectionSheet = true
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

#Preview {
    @Previewable @State var showAddBudgetAlert: Bool = false
    @Previewable @State var showBudgetSelectionSheet: Bool = false
    NoBudgetsView(showAddBudgetAlert: $showAddBudgetAlert, showBudgetSelectionSheet: $showBudgetSelectionSheet)
}
