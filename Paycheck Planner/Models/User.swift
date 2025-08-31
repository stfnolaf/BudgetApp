//
//  Profile.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 8/17/25.
//

import Foundation
import SwiftData

// Main container for all of the user's financial data.
@Model
final class User {
    // Using '@Relationship(deleteRule: .cascade)' ensures that when a User is deleted,
    // all of their associated financial data is also automatically deleted.
    @Relationship(deleteRule: .cascade, inverse: \IncomeStream.user) var incomeStreams: [IncomeStream] = []
    @Relationship(deleteRule: .cascade, inverse: \Expense.user) var expenses: [Expense] = []
    @Relationship(deleteRule: .cascade, inverse: \ExpenseCategory.user) var expenseCategories: [ExpenseCategory] = []
    @Relationship(deleteRule: .cascade, inverse: \Investment.user) var investments: [Investment] = []
    @Relationship(deleteRule: .cascade, inverse: \Budget.user) var budgets: [Budget] = []
    
    init(){}
}
