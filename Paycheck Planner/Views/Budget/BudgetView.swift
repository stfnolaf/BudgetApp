//
//  SpendView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//

import SwiftUI
import SwiftData

struct BudgetView: View {
    let user: User
    let budget: Budget
    @Binding var expandedCategories: Set<String>
    var onSelectBudget: () -> Void
    
    var onDeleteItem: (IndexSet, ExpenseCategory) -> Void
    
    @State private var showingNewExpenseSheet = false

    private var totalMonthlyExpenditures: Double {
        budget.items.reduce(0) { $0 + $1.convertedAmount(to: .monthly) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(budget.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    onSelectBudget()
                }) {
                    Image(systemName: "list.bullet")
                }
            }
            .padding()
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(user.expenseCategories.sorted(by: {$0.totalBudgetedAmount(for: budget, frequency: .monthly) > $1.totalBudgetedAmount(for: budget, frequency: .monthly) }), id: \.self) { category in
                        let itemsForCategory = budget.items.filter {$0.category == category}
                        CategorySectionView(
                            category: category,
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
                                self.onDeleteItem(offsets, category)
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
                    Text("$\(totalMonthlyExpenditures, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                .padding()
                Button(action: {
                    showingNewExpenseSheet = true
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
        .sheet(isPresented: $showingNewExpenseSheet) {
            NewBudgetItemView(user: user, budget: budget)
        }
    }
}

// The PREVIEW for the container is the one that needs the complex setup.
#Preview {
    @Previewable @State var expandedCategories: Set<String> = []
    let budget = Budget.forPreview
    let user = budget.user!
    return BudgetView(user: user, budget: budget, expandedCategories: $expandedCategories, onSelectBudget: {}, onDeleteItem: {offsets, category in })
}
