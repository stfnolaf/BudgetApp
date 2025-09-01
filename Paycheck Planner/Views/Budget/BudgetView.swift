//
//  SpendView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//

import SwiftUI
import SwiftData

struct BudgetView: View {
    // Inputs
    let budget: Budget
    let categories: [ExpenseCategory]

    // State
    @State private var expandedCategories: Set<String> = []
    @State private var showNewExpenseSheet: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ScrollView {
                LazyVStack(alignment: .center, spacing: 20) {
                    ForEach(categories.sorted(by: {budget.categoricalBudgetedExpenses(for: $0, frequency: .monthly) > budget.categoricalBudgetedExpenses(for: $1, frequency: .monthly) }), id: \.self) { category in
                        let itemsForCategory = budget.items.filter {$0.category == category}
                        BudgetCategorySectionView(
                            categoryName: category.name,
                            budgetItems: itemsForCategory,
                            isExpanded: Binding(
                                get: { expandedCategories.contains(category.name) },
                                set: { isExpanded in
                                    if isExpanded {
                                        expandedCategories.insert(category.name)
                                    } else {
                                        expandedCategories.remove(category.name)
                                    }
                                }
                            ),
                            onDeleteItem: { offsets in
                                
                            }
                        )
                    }
                }
                .padding()
            }
            .background(.ultraThinMaterial)
            VStack {
                HStack {
                    Text("Planned Expenditures")
                        .font(.headline)
                    Spacer()
                    Text("$\(budget.totalBudgetedExpenses(frequency: .monthly), specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                .padding()
                Button(action: {
                    showNewExpenseSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Expense")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor.opacity(0.15))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
        .sheet(isPresented: $showNewExpenseSheet) {
            NewBudgetItemView(budget: budget, categories: categories)
        }
    }
}

#Preview {
    ({
        let budget = Budget.forPreview
        var categories: [ExpenseCategory] = []
        for item in budget.items {
            if !categories.contains(where: { $0 == item.category }) {
                categories.append(item.category)
            }
        }
        return BudgetView(budget: budget, categories: categories)
    })()
}
