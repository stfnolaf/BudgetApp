//
//  SpendView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//

import SwiftUI
import SwiftData

struct CategorySectionView: View {
    let category: Expense.ExpenseCategory
    let expenses: [BudgetItem]
    @Binding var isExpanded: Bool

    var categoryTotal: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        Section {
            HStack {
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.accentColor)
                }
                Text(category.rawValue)
                    .font(.headline)
                Spacer()
                Text("$\(categoryTotal, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
            }
            .contentShape(Rectangle()) // Makes entire row tappable
            .onTapGesture { isExpanded.toggle() }

            if isExpanded {
                if expenses.isEmpty {
                    Text("No expenses in this category")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(expenses, id: \.persistentModelID) { expense in
                        HStack {
                            Text(expense.name)
                            Spacer()
                            Text("$\(expense.amount, specifier: "%.2f")")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
    }
}

struct BudgetEditingView: View {
    let budget: Budget
    @State private var showingNewExpenseSheet = false
    @State private var expandedCategories: Set<String> = []

    var totalMonthlyExpenditures: Double {
        budget.items.reduce(0) { $0 + $1.convertedAmount(to: .monthly) }
    }
    var body: some View {
        VStack {
            List {
                ForEach(Expense.ExpenseCategory.allCases, id: \.self) { category in
                    let categoryExpenses = budget.items.filter {$0.category == category}
                    CategorySectionView(
                        category: category,
                        expenses: categoryExpenses,
                        isExpanded: Binding(
                            get: { expandedCategories.contains(category.rawValue) },
                            set: { isExpanded in
                                if isExpanded {
                                    expandedCategories.insert(category.rawValue)
                                } else {
                                    expandedCategories.remove(category.rawValue)
                                }
                            }
                        )
                    )
                }
            }
            .listStyle(.inset)
            VStack {
                Divider()
                HStack {
                    Text("Planned Expenditures")
                        .font(.headline)
                    Spacer()
                    Text("$\(totalMonthlyExpenditures, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                .padding([.horizontal, .bottom])
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
            NewExpenseView()
        }
    }
}

struct BudgetView: View {
    let budget: Budget?
    @State private var showBudgetSelection = false
    
    @State private var budgetFrequency: BudgetItem.BudgetFrequency = .monthly

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(budget?.name ?? "")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .horizontal])
                    Spacer()
                    NavigationLink(destination: BudgetSelectionView()) {
                        Image(systemName: "list.bullet")
                    }
                    .padding([.top, .horizontal])
                }
                Spacer()
                if let workingBudget = budget {
                    BudgetEditingView(budget: workingBudget)
                } else {
                    VStack {
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
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    let budget = Budget(name: "Monthly Essentials")
    
    let rent = BudgetItem(name: "Rent", amount: 2200, category: .housing, frequency: .monthly)
    let groceries = BudgetItem(name: "Groceries", amount: 450, category: .food, frequency: .monthly)
    let internet = BudgetItem(name: "Internet", amount: 80, category: .utilities, frequency: .monthly)
    
    budget.items = [rent, groceries, internet]
    return BudgetView(budget: budget)
}
