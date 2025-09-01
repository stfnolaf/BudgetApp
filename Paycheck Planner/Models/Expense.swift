//
//  ExpenseCategory.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 8/31/25.
//

import Foundation
import SwiftData

@Model
final class Expense {
    var name: String
    var amount: Double
    @Relationship(deleteRule: .nullify) var category: ExpenseCategory?
    var date: Date

    init(name: String, amount: Double, category: ExpenseCategory?, date: Date) {
        self.name = name
        self.amount = amount
        self.category = category
        self.date = date
    }
}

@Model
final class ExpenseCategory: Equatable {
    @Attribute(.unique) var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \Expense.category) var expenses: [Expense] = []
    @Relationship(deleteRule: .cascade, inverse: \BudgetItem.category) var budgetItems: [BudgetItem] = []
    
    init(name: String) {
        self.name = name
    }
    
    static func == (lhs: ExpenseCategory, rhs: ExpenseCategory) -> Bool {
        lhs.name == rhs.name
    }
}
