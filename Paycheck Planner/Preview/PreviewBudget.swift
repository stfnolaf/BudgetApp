//
//  PreviewBudget.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 8/28/25.
//

extension Budget {
    /// A static, pre-configured Budget instance for use in SwiftUI previews.
    static var forPreview: Budget {
        let user = User()
        
        let foodCategory = ExpenseCategory(name: "Food")
        foodCategory.user = user
        
        let transportCategory = ExpenseCategory(name: "Transportation")
        transportCategory.user = user
        
        let budget = Budget(name: "Monthly Essentials")
        budget.user = user

        let groceries = BudgetItem(name: "Groceries", amount: 450, category: foodCategory, frequency: .monthly)
        groceries.budget = budget
        
        let gas = BudgetItem(name: "Gas", amount: 120, category: transportCategory, frequency: .monthly)
        gas.budget = budget
        
        let restaurants = BudgetItem(name: "Restaurants", amount: 200, category: foodCategory, frequency: .monthly)
        restaurants.budget = budget
        
        budget.items = [groceries, gas, restaurants]
        foodCategory.budgetItems = [groceries, restaurants]
        transportCategory.budgetItems = [gas]

        return budget
    }
}
