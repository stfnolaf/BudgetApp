//
//  BudgetCategorySectionView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 8/31/25.
//

import SwiftUI

struct BudgetCategorySectionView: View {
    let categoryName: String
    let budgetItems: [BudgetItem]
    @Binding var isExpanded: Bool
    
    var onDeleteItem: (IndexSet) -> Void
    
    private var categoryTotal: Double {
        budgetItems.reduce(0) { $0 + $1.convertedAmount(to: .monthly) }
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                Text(categoryName)
                    .font(.headline)
                Spacer()
                Text("$\(categoryTotal, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
            }
            .contentShape(Rectangle()) // Makes entire HStack tappable
            .onTapGesture {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }

            if isExpanded {
                Divider().padding(.vertical, 4)
                if budgetItems.isEmpty {
                    Text("No expenses in this category")
                        .foregroundColor(.secondary)
                        .padding(.leading)
                } else {
                    ForEach(budgetItems.sorted(by: {$0.amount > $1.amount}), id: \.persistentModelID) { expense in
                        HStack {
                            Text(expense.name)
                            Spacer()
                            Text("$\(expense.amount, specifier: "%.2f")")
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading)
                        .padding(6)
                    }
                    .onDelete(perform: onDeleteItem)
                }
            }
        }
        .padding()
        .background {
            if isExpanded {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.white))
            } else {
                Capsule()
                    .fill(Color(.white))
            }
        }
        
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
    }
}

#Preview {
    @Previewable @State var isExpanded = true
    BudgetCategorySectionView(categoryName: "Test Category", budgetItems: [], isExpanded: $isExpanded, onDeleteItem: {_ in })
}
