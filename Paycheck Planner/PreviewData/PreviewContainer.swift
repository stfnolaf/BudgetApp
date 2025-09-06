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
        let schema = Schema([
            Budget.self,
            BudgetItem.self,
            ExpenseCategory.self,
            Expense.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            container = try ModelContainer(for: schema, configurations: [config])
            let context = container.mainContext
                                    
            let housing = ExpenseCategory(name: "Housing")
            context.insert(housing)
            
            let food = ExpenseCategory(name: "Food")
            context.insert(food)
            
            let utilities = ExpenseCategory(name: "Utilities")
            context.insert(utilities)
                        
            let budget = Budget(name: "Monthly Essentials")
            context.insert(budget)

            let rent = BudgetItem(name: "Rent", amount: 2200, category: housing, frequency: .monthly)
            rent.budget = budget
            context.insert(rent)
            
            let groceries = BudgetItem(name: "Groceries", amount: 450, category: food, frequency: .monthly)
            groceries.budget = budget
            context.insert(groceries)
            
            let internet = BudgetItem(name: "Internet", amount: 80, category: utilities, frequency: .monthly)
            internet.budget = budget
            context.insert(internet)
            
            return container
        } catch {
            fatalError("Failed to create container for previewing: \(error.localizedDescription)")
        }
    }
}
