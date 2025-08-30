//
//  PreviewBudget.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 8/28/25.
//

extension Budget {
    /// A static, pre-configured Budget instance for use in SwiftUI previews.
    static var forPreview: Budget {
        // 1. Create the main budget object.
        let budget = Budget(name: "Monthly Essentials")

        // 2. Create the categories that will belong to this budget.
        let foodCategory = ExpenseCategory(name: "Food")
        foodCategory.budget = budget
        
        let transportCategory = ExpenseCategory(name: "Transportation")
        transportCategory.budget = budget
        
        // 3. Add the categories to the budget's list.
        budget.expenseCategories = [foodCategory, transportCategory]

        // 4. Create the budget items and link them to their respective categories and the budget.
        let groceries = BudgetItem(name: "Groceries", amount: 450, category: foodCategory, frequency: .monthly)
        
        let gas = BudgetItem(name: "Gas", amount: 120, category: transportCategory, frequency: .monthly)
        
        let restaurants = BudgetItem(name: "Restaurants", amount: 200, category: foodCategory, frequency: .monthly)

        // 5. Add the items to the budget's list.
        budget.items = [groceries, gas, restaurants]

        // 6. Return the fully configured budget.
        return budget
    }
}
