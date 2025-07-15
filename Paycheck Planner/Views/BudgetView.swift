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
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
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
                },
                label: {
                    HStack {
                        Text(category)
                            .font(.headline)
                        Spacer()
                        Text("$\(categoryTotal, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.accentColor)
                    }
                }
            )
        }
    }
}

struct BudgetView: View {
    @Bindable var viewModel: ContentView.ViewModel
    @Binding var selectedTab: ContentView.Tab
    
    @State private var expandedCategories: Set<String> = []
    @State private var showingNewExpenseSheet = false
    
    @State private var showingAddListAlert = false
    @State private var newListName = ""
    
    var selectedExpenseList : Budget? {
        if viewModel.selectedExpenseList == nil, !viewModel.expenseLists.isEmpty {
            viewModel.selectedExpenseList = viewModel.expenseLists[0]
        }
        return viewModel.selectedExpenseList
    }
    
    var expenses: [Expense] {
        selectedExpenseList?.expenses ?? []
    }
    
    var expenseCategories: [String] {
        selectedExpenseList?.expenseCategories ?? []
    }
    
    var expensesByCategory: [String: [Expense]] {
        Dictionary(grouping: expenses) { $0.category }
    }

    var totalExpenditures: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        if selectedExpenseList == nil {
            VStack {
                Spacer()
                Text("No budgets have been set up yet!")
                Button(action: {
                    showingAddListAlert = true
                }) {
                    Text("New Budget")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .background(Color.accentColor.opacity(0.15))
                        .cornerRadius(12)
                }
                .alert("New Expense List", isPresented: $showingAddListAlert) {
                    TextField("List Name", text: $newListName)
                    Button("Add", action: {
                        if !newListName.trimmingCharacters(in: .whitespaces).isEmpty {
                            viewModel.addExpenseList(Budget(newListName))
                            newListName = ""
                            selectedTab = .spend
                        }
                    })
                    Button("Cancel", role: .cancel) {
                        newListName = ""
                    }
                } message: {
                    Text("Please enter a name for your new expense list.")
                }
                Spacer()
            }
            .navigationTitle("Expenses")
        } else {
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
                .listStyle(.insetGrouped)
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
            .navigationTitle("Expenses")
            .sheet(isPresented: $showingNewExpenseSheet) {
                NewExpenseView(expenseCategories: expenseCategories)
            }
        }
    }
}
