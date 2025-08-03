//
//  ExpenseList.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/13/25.
//

import Foundation
import SwiftData

enum Frequency: String, Codable, CaseIterable, Identifiable {
    case weekly
    case biweekly
    case monthly
    case semimonthly
    case quarterly
    case annually
    case oneTime
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .weekly: return "Weekly"
        case .biweekly: return "Biweekly"
        case .monthly: return "Monthly"
        case .semimonthly: return "Semimonthly"
        case .quarterly: return "Quarterly"
        case .annually: return "Annually"
        case .oneTime: return "One Time"
        }
    }
}

@Model
final class Expense {
    @Attribute(.unique) var id: UUID
    var category: String
    var amount: Double
    @Attribute(.unique) var title: String
    var frequency: Frequency
    
    @Relationship(inverse: \Budget.expenses)
    var list: Budget?

    init(
        id: UUID = UUID(),
        category: String = "",
        amount: Double = 0.0,
        title: String = "",
        frequency: Frequency = .monthly
    ) {
        self.id = id
        self.category = category
        self.amount = amount
        self.title = title
        self.frequency = frequency
    }
}

@Model
final class Budget {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String
    static let defaultExpenseCategories = ["Rent", "Utilities", "Subscriptions", "Transportation", "Groceries", "Splurge", "Smile"]

    var expenseCategories: [String]
    
    @Relationship
    var expenses: [Expense]
    
    init(
        _ name: String,
        id: UUID = UUID(),
        expenseCategories: [String] = Budget.defaultExpenseCategories,
        expenses: [Expense] = [])
    {
        self.id = id
        self.name = name
        self.expenseCategories = expenseCategories
        self.expenses = expenses
    }
}
