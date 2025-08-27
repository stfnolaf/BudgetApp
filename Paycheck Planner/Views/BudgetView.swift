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
                Text(category.name)
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

struct BudgetView: View {
    @Environment(\.workingBudget) private var workingBudget
    @Environment(\.currentUser) private var currentUser
    @State private var showingNewExpenseSheet = false
    @State private var expandedCategories: Set<String> = []

    private var totalMonthlyExpenditures: Double {
        guard let budget = workingBudget.wrappedValue else { return 0.0 }
        return budget.items.reduce(0) { $0 + $1.convertedAmount(to: .monthly) }
    }
    
    @State private var showBudgetSelection = false
    @State private var budgetFrequency: BudgetItem.BudgetFrequency = .monthly

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(workingBudget.wrappedValue?.name ?? "")
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
                if let user = currentUser, let budget = workingBudget.wrappedValue {
                    VStack {
                        List {
                            ForEach(user.expenseCategories.sorted(by: {$0.name < $1.name }), id: \.self) { category in
                                let categoryExpenses = workingBudget.wrappedValue!.items.filter {$0.category == category}
                                CategorySectionView(
                                    category: category,
                                    expenses: categoryExpenses,
                                    isExpanded: Binding(
                                        get: { expandedCategories.contains(category.name) },
                                        set: { isExpanded in
                                            if isExpanded {
                                                expandedCategories.insert(category.name)
                                            } else {
                                                expandedCategories.remove(category.name)
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
    BudgetView()
}
