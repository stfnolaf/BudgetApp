//
//  SpendView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//

import SwiftUI
import SwiftData

struct CategorySectionView: View {
    let category: ExpenseCategory
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
                Text(category.name)
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

struct BudgetView: View {
    let budget: Budget
    @Binding var expandedCategories: Set<String>
    var onSelectBudget: () -> Void
    
    var onDeleteCategory: (IndexSet) -> Void
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
                    //.frame(maxWidth: .infinity, alignment: .leading)
                    //.padding([.horizontal])
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
                    ForEach(budget.expenseCategories.sorted(by: {$0.totalBudgetedAmount > $1.totalBudgetedAmount }), id: \.self) { category in
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
                    .onDelete(perform: onDeleteCategory)
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
            NewBudgetItemView(budget: budget)
        }
    }
}

// This is the new "smart" container.
struct BudgetContainerView: View {
    @Environment(\.workingBudget) private var workingBudget
    @Environment(\.modelContext) private var modelContext
    @State private var expandedCategories: Set<String> = []
    @State private var showBudgetSelectionSheet = false

    var body: some View {
        // It contains the logic to decide which view to show.
        if let budget = workingBudget.wrappedValue {
            // If a budget is selected, it passes the data down to the dumb view.
            BudgetView(
                budget: budget,
                expandedCategories: $expandedCategories,
                onSelectBudget: {
                    showBudgetSelectionSheet = true
                },
                onDeleteCategory: { offsets in
                    deleteCategory(at: offsets, for: budget)
                },
                onDeleteItem: { offsets, category in
                    deleteItem(at: offsets, in: category, for: budget)
                }
            )
            .sheet(isPresented: $showBudgetSelectionSheet) {
                BudgetSelectionView()
            }
        } else {
            // It handles the "no budget" case.
            VStack {
                Spacer()
                Text("No budgets created yet!")
                Button(action: {

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
    
    private func deleteCategory(at offsets: IndexSet, for budget: Budget) {
        let sortedCategories = budget.expenseCategories.sorted(by: { $0.totalBudgetedAmount > $1.totalBudgetedAmount })
            for index in offsets {
                let categoryToDelete = sortedCategories[index]
                modelContext.delete(categoryToDelete)
            }
        }

        private func deleteItem(at offsets: IndexSet, in category: ExpenseCategory, for budget: Budget) {
            let itemsForCategory = budget.items.filter { $0.category == category }
            for index in offsets {
                let itemToDelete = itemsForCategory[index]
                modelContext.delete(itemToDelete)
            }
        }
}

// The PREVIEW for the container is the one that needs the complex setup.
#Preview {
    @Previewable @State var expandedCategories: Set<String> = []
    return BudgetView(budget: Budget.forPreview, expandedCategories: $expandedCategories, onSelectBudget: {}, onDeleteCategory: {offsets in }, onDeleteItem: {offsets, category in })
}
