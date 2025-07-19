//
//  SpendView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//

import SwiftUI
import SwiftData

struct CategorySectionView: View {
    let category: String
    let expenses: [Expense]
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
                Text(category)
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
                    ForEach(expenses, id: \.id) { expense in
                        HStack {
                            Text(expense.title)
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
    
    var expenses: [Expense] {
        budget.expenses
    }
    
    var expenseCategories: [String] {
        budget.expenseCategories
    }
    
    var expensesByCategory: [String: [Expense]] {
        Dictionary(grouping: expenses) { $0.category }
    }

    var totalExpenditures: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    var body: some View {
        VStack {
            List {
                ForEach(expenseCategories, id: \.self) { category in
                    let categoryExpenses = expensesByCategory[category] ?? []
                    CategorySectionView(
                        category: category,
                        expenses: categoryExpenses,
                        isExpanded: Binding(
                            get: { expandedCategories.contains(category) },
                            set: { isExpanded in
                                if isExpanded {
                                    expandedCategories.insert(category)
                                } else {
                                    expandedCategories.remove(category)
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
                    Text("Total Expenditures")
                        .font(.headline)
                    Spacer()
                    Text("$\(totalExpenditures, specifier: "%.2f")")
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
            NewExpenseView(expenseCategories: expenseCategories)
        }
    }
}

struct BudgetView: View {
    @Binding var selectedTab: ContentView.Tab
    
    @Environment(AppState.self) var appState
        
    @State private var showBudgetSelection = false

    var body: some View {
        NavigationStack {
            HStack {
                Text(appState.workingBudget?.name ?? "")
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
            if let budget = appState.workingBudget {
                BudgetEditingView(budget: budget)
            } else {
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
    }
}

#Preview {
    @Previewable @State var selectedTab: ContentView.Tab = .budget
    var rent = Expense(category: "Rent", amount: 3500, title: "Rent", frequency: .monthly)
    var groceries = Expense(category: "Groceries", amount: 300, title: "Food", frequency: .monthly)
    var internet = Expense(category: "Utilities", amount: 80, title: "Internet", frequency: .monthly)
    let previewAppState = AppState()
    previewAppState.workingBudget = Budget("My Budget", expenses: [rent, groceries, internet])
    
    return BudgetView(selectedTab: $selectedTab)
        .environment(previewAppState)
}
