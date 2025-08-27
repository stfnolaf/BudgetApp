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
    @Relationship(deleteRule: .cascade) var incomeStreams: [IncomeStream] = []
    @Relationship(deleteRule: .cascade) var expenseCategories: [ExpenseCategory] = []
    @Relationship(deleteRule: .cascade) var expenses: [Expense] = []
    @Relationship(deleteRule: .cascade) var investments: [Investment] = []
    @Relationship(deleteRule: .cascade) var budgets: [Budget] = []
    
    init(){}
}
