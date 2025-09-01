//
//  ExpenseList.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/13/25.
//

import Foundation
import SwiftData

// Represents a user-defined budget for planning purposes.
@Model
final class Budget {
    @Attribute(.unique) var name: String // e.g., "Monthly Minimums", "Ideal Spending Plan"
    
    @Relationship(deleteRule: .cascade, inverse: \BudgetItem.budget) var items: [BudgetItem] = []
    
    func totalBudgetedExpenses(frequency: BudgetItem.BudgetFrequency) -> Double {
        return self.items.reduce(0) { $0 + $1.convertedAmount(to: frequency) }
    }
    
    func categoricalBudgetedExpenses(for category: ExpenseCategory, frequency: BudgetItem.BudgetFrequency) -> Double {
        return self.items.filter { $0.category == category }.reduce(0) { $0 + $1.convertedAmount(to: frequency) }
    }

    init(name: String) {
        self.name = name
    }
}

// Represents a single recurring expense item within a budget.
@Model
final class BudgetItem {
    var name: String // e.g., "Rent", "Netflix", "Groceries"
    var amount: Double
    var category: ExpenseCategory
    var budget: Budget?
    var frequency: BudgetFrequency
    init(name: String, amount: Double, category: ExpenseCategory, frequency: BudgetFrequency) {
        self.name = name
        self.amount = amount
        self.category = category
        self.frequency = frequency
    }
    
    func convertedAmount(to newFrequency: BudgetFrequency) -> Double {
        let annualAmount = self.amount * self.frequency.annualMultiplier
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
