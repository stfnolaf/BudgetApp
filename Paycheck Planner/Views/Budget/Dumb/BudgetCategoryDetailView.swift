//
//  BudgetCategoryDetailView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 9/3/25.
//

import SwiftUI

struct BudgetCategoryDetailView: View {
    let categoryName: String
    let categoryTotal: Double
    let budgetItems: [BudgetItem]
    
    var onDeleteItem: (IndexSet) -> Void

    var body: some View {
        List {
            ForEach(budgetItems.sorted(by: {$0.convertedAmount(to: .monthly) > $1.convertedAmount(to: .monthly)}), id: \.self) { item in
                HStack {
                    Text(item.name)
                        .font(.subheadline)
                    Spacer()
                    Text("$\(item.convertedAmount(to: .monthly), specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.leading)
                .padding(.vertical, 6)
            }
            .onDelete(perform: onDeleteItem)
        }
    }
}

#Preview {
    BudgetCategoryDetailView(categoryName: "Category Name", categoryTotal: 0, budgetItems: Budget.forPreview.items, onDeleteItem: {set in })
}
