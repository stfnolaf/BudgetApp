//
//  PreviewContainer.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 8/24/25.
//

import SwiftData

extension ModelContainer {
    @MainActor
    static var forPreview: ModelContainer {
        let container: ModelContainer
        // 1. Add ExpenseCategory to the schema
        let schema = Schema([
            User.self,
            IncomeStream.self,
            Tax.self,
            RetirementContribution.self,
            Expense.self,
            Budget.self,
            BudgetItem.self,
            Investment.self,
            ExpenseCategory.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            container = try ModelContainer(for: schema, configurations: [config])
            let context = container.mainContext
            
            // --- Pre-populate with sample data ---
            
            let user = User()
            
            let housing = ExpenseCategory(name: "Housing")
            let food = ExpenseCategory(name: "Food")
            let utilities = ExpenseCategory(name: "Utilities")
                        
            let budget = Budget(name: "Monthly Essentials")
            budget.user = user
            budget.expenseCategories = [housing, food, utilities]

            let rent = BudgetItem(name: "Rent", amount: 2200, category: housing, frequency: .monthly)
            rent.budget = budget
            
            let groceries = BudgetItem(name: "Groceries", amount: 450, category: food, frequency: .monthly)
            groceries.budget = budget
            
            let internet = BudgetItem(name: "Internet", amount: 80, category: utilities, frequency: .monthly)
            internet.budget = budget
            
            context.insert(user)
            context.insert(budget)
            context.insert(housing)
            context.insert(food)
            context.insert(utilities)
            context.insert(rent)
            context.insert(groceries)
            context.insert(internet)
            
            // --- End of sample data ---
            
            return container
        } catch {
            fatalError("Failed to create container for previewing: \(error.localizedDescription)")
        }
    }
}
