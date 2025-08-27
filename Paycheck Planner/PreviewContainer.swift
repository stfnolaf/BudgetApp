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
            
            // 2. Create the User with a name
            let user = User()
            
            // 3. Create sample categories
            let housing = ExpenseCategory(name: "Housing")
            let food = ExpenseCategory(name: "Food")
            let utilities = ExpenseCategory(name: "Utilities")
            
            // 4. Link categories to the user
            user.expenseCategories = [housing, food, utilities]
            
            // 5. Create a budget and link it to the user
            let budget = Budget(name: "Monthly Essentials")
            budget.user = user
            
            // 6. Create budget items using the category objects
            let rent = BudgetItem(name: "Rent", amount: 2200, category: housing, frequency: .monthly)
            rent.budget = budget
            
            let groceries = BudgetItem(name: "Groceries", amount: 450, category: food, frequency: .monthly)
            groceries.budget = budget
            
            let internet = BudgetItem(name: "Internet", amount: 80, category: utilities, frequency: .monthly)
            internet.budget = budget
            
            // 7. Insert all the top-level objects into the context.
            //    SwiftData will handle saving the relationships.
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
