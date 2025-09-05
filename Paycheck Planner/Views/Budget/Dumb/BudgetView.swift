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
    @State private var showNewExpenseSheet: Bool = false
    @State private var expandedCategories: Set<String> = []
    private let period: BudgetItem.BudgetFrequency = .monthly
    
    var body: some View {
        let categories = categories.sorted(by: {budget.categoricalBudgetedExpenses(for: $0, frequency: period) > budget.categoricalBudgetedExpenses(for: $1, frequency: period)}).filter { $0.budgetItems.isEmpty == false }
        NavigationStack {
            VStack(alignment: .center, spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(categories) { category in
                            let itemsForCategory = category.budgetItems.sorted(by: {$0.convertedAmount(to: period) > $1.convertedAmount(to: period)})
                            let categoryTotal = itemsForCategory.reduce(0) {$0 + $1.convertedAmount(to: period)}
                                
                            let isExpanded = expandedCategories.contains(category.name)
                            
                            Grid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 12) {
                                GridRow {
                                    HStack(spacing: 4) {
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.secondary)
                                            .rotationEffect(.degrees(isExpanded ? 90: 0))
                                            .padding(.trailing, 8)
                                        
                                        Text(category.name)
                                            .font(.title3)
                                            .bold()
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(String(format: "$%.2f", categoryTotal))
                                        .font(.headline)
                                        .foregroundColor(.accentColor)
                                        .gridColumnAlignment(.trailing)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        if isExpanded {
                                            expandedCategories.remove(category.name)
                                        } else {
                                            expandedCategories.insert(category.name)
                                        }
                                    }
                                }
                                
                                if isExpanded {
                                    ForEach(itemsForCategory) { item in
                                        GridRow {
                                            Text(item.name)
                                                .padding(.leading, 25)
                                            Text(String(format: "$%.2f", item.amount))
                                                .gridColumnAlignment(.trailing)
                                        }
                                        .transition(.move(edge: .top).combined(with: .opacity))
                                    }
                                }
                            }
                            .padding(.vertical, 20)
                            
                            if category.name != categories.last?.name {
                                Divider()
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .background(.ultraThinMaterial)
                VStack {
                    HStack {
                        Text("Fixed Expenses")
                            .font(.headline)
                        Spacer()
                        Text("$\(budget.totalBudgetedExpenses(frequency: period), specifier: "%.2f")")
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
                    Text(budget.name)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            print("Options selected")
                        }) {
                            Label("Options", systemImage: "slider.horizontal.3")
                        }
                        Button(action: {
                            print("Manage Budgets")
                        }) {
                            Label("Manage Budgets", systemImage: "list.bullet.rectangle.portrait.fill")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
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
