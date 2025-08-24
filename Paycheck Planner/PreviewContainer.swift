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
            User.self,
            IncomeStream.self,
            Tax.self,
            RetirementContribution.self,
            Expense.self,
            Budget.self,
            BudgetItem.self,
            Investment.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            // Remember to list all your models here
            container = try ModelContainer(for: schema, configurations: [config])
            
            // --- Pre-populate with sample data ---
            let user = User()
            
            let budget = Budget(name: "Monthly Essentials")
            
            let rent = BudgetItem(name: "Rent", amount: 2200, category: .housing, frequency: .monthly)
            let groceries = BudgetItem(name: "Groceries", amount: 450, category: .food, frequency: .monthly)
            let internet = BudgetItem(name: "Internet", amount: 80, category: .utilities, frequency: .monthly)
            
            budget.items = [rent, groceries, internet]
            budget.user = user
            user.budgets = [budget]
            
            container.mainContext.insert(user)
            // --- End of sample data ---
            
            return container
        } catch {
            fatalError("Failed to create container for previewing: \(error.localizedDescription)")
        }
    }
}
