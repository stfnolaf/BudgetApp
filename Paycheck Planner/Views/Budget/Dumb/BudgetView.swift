//
//  BudgetView2.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//

import SwiftUI
import SwiftData

// Defines a new vertical alignment line named "amount" for our views to follow.
extension HorizontalAlignment {
    private enum AmountAlignment : AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            // Default to aligning with the trailing edge.
            return context[HorizontalAlignment.trailing]
        }
    }
    static let amount = HorizontalAlignment(AmountAlignment.self)
}

struct BudgetView: View {
    // Inputs
    let budget: Budget
    let categories: [ExpenseCategory]
    let onAddBudgetItem: (String, Budget, ExpenseCategory, Double, BudgetItem.BudgetFrequency) -> Void
    let onDeleteBudgetItem: (BudgetItem) -> Void
    @Binding var showBudgetSelectionSheet: Bool

    // State
    @State private var showNewExpenseSheet: Bool = false
    @State private var expandedCategories: Set<String> = []
    @State private var period: BudgetItem.BudgetFrequency = .monthly
    
    var body: some View {
        let categories = categories.sorted(by: {budget.categoricalBudgetedExpenses(for: $0, frequency: period) > budget.categoricalBudgetedExpenses(for: $1, frequency: period)}).filter { $0.budgetItems.isEmpty == false }
        NavigationStack {
            VStack(alignment: .amount, spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(categories) { category in
                            let itemsForCategory = category.budgetItems.sorted(by: {$0.convertedAmount(to: period) > $1.convertedAmount(to: period)})
                            let categoryTotal = itemsForCategory.reduce(0) {$0 + $1.convertedAmount(to: period)}
                                
                            
                            HStack {
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.bold))
                                    .rotationEffect(.degrees(isExpanded(category) ? 90 : 0))
                                Text(category.name)
                                    .font(.headline)
                                Spacer()
                                Text(categoryTotal, format: .currency(code: "USD"))
                                    .font(.headline)
                                    .alignmentGuide(.amount) { d in d[HorizontalAlignment.trailing] }
                            }
                            .padding()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    toggleExpansion(for: category)
                                }
                            }
                            
                            if isExpanded(category) {
                                ForEach(itemsForCategory) { item in
                                    HStack {
                                        Text(item.name)
                                            .padding(.leading, 30)
                                        Spacer()
                                        Text(item.amount, format: .currency(code: "USD"))
                                            .alignmentGuide(.amount) { d in d[HorizontalAlignment.trailing] }
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .contentShape(Rectangle())
                                    .swipeActions(allowsFullSwipe: false) {
                                        Button(role: .destructive) {
                                            onDeleteBudgetItem(item)
                                        } label: {
                                            Label("Delete", systemImage: "trash.fill")
                                        }
                                    }
                                    .transition(.move(edge: .top).combined(with: .opacity))
                                }
                            }
                            if(category.name != categories.last?.name) {
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
    
    private func isExpanded(_ category: ExpenseCategory) -> Bool {
        expandedCategories.contains(category.name)
    }
    
    private func toggleExpansion(for category: ExpenseCategory) {
        if isExpanded(category) {
            expandedCategories.remove(category.name)
        } else {
            expandedCategories.insert(category.name)
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
        return BudgetView(budget: budget, categories: categories, onAddBudgetItem: { name, budget, category, amount, frequency in }, onDeleteBudgetItem: {_ in }, showBudgetSelectionSheet: $showBudgetSelectionSheet)
    })()
}
