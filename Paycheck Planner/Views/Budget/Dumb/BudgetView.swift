//
//  BudgetView2.swift
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
    let onAddBudgetItem: (String, Budget, ExpenseCategory, Double, BudgetItem.BudgetFrequency) -> Void
    @Binding var showBudgetSelectionSheet: Bool

    // State
    @State private var expandedCategories: Set<String> = []
    @State private var showNewExpenseSheet: Bool = false
    @State private var categoryIsPressed: Bool = false
    
    var body: some View {
        let categories = categories.sorted(by: {budget.categoricalBudgetedExpenses(for: $0, frequency: .monthly) > budget.categoricalBudgetedExpenses(for: $1, frequency: .monthly)})
        NavigationStack {
            VStack(alignment: .center, spacing: 0) {
                List {
                    ForEach(categories, id: \.self) { category in
                        let itemsForCategory = budget.items.filter {$0.category == category}
                        let categoryTotal = itemsForCategory.reduce(0) {$0 + $1.convertedAmount(to: .monthly)}
                        if !itemsForCategory.isEmpty {
                            NavigationLink(
                                destination: BudgetCategoryDetailView(
                                    categoryName: category.name,
                                    categoryTotal: categoryTotal,
                                    budgetItems: itemsForCategory,
                                    onDeleteItem: {set in }
                                )
                                .toolbar {
                                    ToolbarItem(placement: .principal) {
                                        Text(category.name)
                                    }
                                }
                            )
                            {
                                HStack {
                                    Text(category.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text("$\(categoryTotal, specifier: "%.2f")")
                                        .foregroundColor(.accentColor)
                                }
                                .padding(20)
                            }
                        }
                    }
                }
                VStack {
                    HStack {
                        Text("Fixed Expenses")
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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(budget.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        Image(systemName: "chevron.down")
                            .font(.footnote)
                    }
                    .foregroundStyle(categoryIsPressed ? .gray : .primary)
                    .animation(.easeInOut(duration: 0.1), value: categoryIsPressed)
                    .onTapGesture {
                        showBudgetSelectionSheet = true
                    }
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                categoryIsPressed = true
                            }
                            .onEnded { _ in
                                categoryIsPressed = false
                            }
                    )
                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        showBudgetSelectionSheet = true
//                    }) {
//                        Image(systemName: "list.bullet")
//                    }
//                }
            }
        }
        .sheet(isPresented: $showNewExpenseSheet) {
            NewBudgetItemView(budget: budget, categories: categories, onCreate: onAddBudgetItem)
        }
    }
}

#Preview {
    @Previewable @State var showBudgetSelectionSheet: Bool = false
    ({
        let budget = Budget.forPreview
        var categories: [ExpenseCategory] = []
        for item in budget.items {
            if !categories.contains(where: { $0 == item.category }) {
                categories.append(item.category)
            }
        }
        return BudgetView(budget: budget, categories: categories, onAddBudgetItem: { name, budget, category, amount, frequency in }, showBudgetSelectionSheet: $showBudgetSelectionSheet)
    })()
}
