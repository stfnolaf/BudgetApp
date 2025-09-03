//
//  BudgetTabHeaderView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 9/2/25.
//

import SwiftUI

struct BudgetTabHeaderView: View {
    let title: String
    @Binding var showBudgetSelectionSheet: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                Image(systemName: "chevron.down")
                Spacer()
                Button(action: {
                    showBudgetSelectionSheet = true
                }) {
                    Image(systemName: "list.bullet")
                }
            }
            .padding()
        }
    }
}

#Preview {
    @Previewable @State var showBudgetSelectionSheet: Bool = false
    BudgetTabHeaderView(title: "My Budget", showBudgetSelectionSheet: $showBudgetSelectionSheet)
    Spacer()
}
