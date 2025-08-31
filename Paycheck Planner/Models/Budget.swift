//
//  ExpenseList.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/13/25.
//

import Foundation
import SwiftData

@Model
final class ExpenseCategory {
    var name: String
    var user: User?
    
    @Relationship(inverse: \Expense.category) var expenses: [Expense] = []
    @Relationship(inverse: \BudgetItem.category) var budgetItems: [BudgetItem] = []
    
    func totalBudgetedAmount(for budget: Budget, frequency: BudgetItem.BudgetFrequency) -> Double {
        budgetItems.filter { $0.budget == budget}
            .reduce(0) { $0 + $1.convertedAmount(to: frequency)}
    }
        
    var totalSpentAmount: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    init(name: String) {
        self.name = name
    }
}

extension ExpenseCategory: Hashable {
    static func == (lhs: ExpenseCategory, rhs: ExpenseCategory) -> Bool {
        lhs.persistentModelID == rhs.persistentModelID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(persistentModelID)
    }
}

// Represents a single, actual expense that has occurred.
@Model
final class Expense {
    var name: String
    var amount: Double
    @Relationship(deleteRule: .nullify) var category: ExpenseCategory?
    var date: Date
    var user: User?

    init(name: String, amount: Double, category: ExpenseCategory?, date: Date) {
        self.name = name
        self.amount = amount
        self.category = category
        self.date = date
    }
}

// Represents a user-defined budget for planning purposes.
@Model
final class Budget {
    var name: String // e.g., "Monthly Minimums", "Ideal Spending Plan"
    var user: User?
    
    @Relationship(deleteRule: .cascade, inverse: \BudgetItem.budget) var items: [BudgetItem] = []

    init(name: String) {
        self.name = name
    }
}

// Represents a single recurring expense item within a budget.
@Model
final class BudgetItem {
    var name: String // e.g., "Rent", "Netflix", "Groceries"
    var amount: Double
    // We can reuse the same category enum from the Expense model.
    @Relationship(deleteRule: .nullify) var category: ExpenseCategory?
    var budget: Budget?
    var frequency: BudgetFrequency
    init(name: String, amount: Double, category: ExpenseCategory?, frequency: BudgetFrequency) {
        self.name = name
        self.amount = amount
        self.category = category
        self.frequency = frequency
    }
    
    func convertedAmount(to newFrequency: BudgetFrequency) -> Double {
        // 1. Convert the item's current amount to its annual equivalent.
        let annualAmount = self.amount * self.frequency.annualMultiplier
        
        // 2. Convert the annual amount to the new frequency.
        return annualAmount / newFrequency.annualMultiplier
    }
}

extension BudgetItem {
    enum BudgetFrequency: String, Codable, CaseIterable {
        case weekly = "Weekly"
        case biweekly = "Biweekly"
        case monthly = "Monthly"
        case quarterly = "Quarterly"
        case annually = "Annually"

        // This helper property makes conversions easy
        var annualMultiplier: Double {
            switch self {
            case .weekly:
                return 52.0
            case .biweekly:
                return 26.0
            case .monthly:
                return 12.0
            case .quarterly:
                return 4.0
            case .annually:
                return 1.0
            }
        }
    }
}
