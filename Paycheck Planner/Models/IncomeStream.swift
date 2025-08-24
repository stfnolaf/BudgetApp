//
//  UserInfo.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//
import Foundation
import SwiftData

// Represents a single source of income, like a salary or freelance work.
@Model
final class IncomeStream {
    var name: String
    var amount: Double
    var payFrequency: PayFrequency
    // A user can have multiple income streams.
    var user: User?

    // Each income stream will have its own set of taxes and retirement contributions.
    @Relationship(deleteRule: .cascade) var taxes: [Tax] = []
    @Relationship(deleteRule: .cascade) var retirementContributions: [RetirementContribution] = []

    init(name: String, amount: Double, payFrequency: PayFrequency) {
        self.name = name
        self.amount = amount
        self.payFrequency = payFrequency
    }

    // Enum to represent how often the income is received.
    enum PayFrequency: String, Codable, CaseIterable {
        case weekly = "Weekly"
        case biWeekly = "Bi-Weekly"
        case semiMonthly = "Semi-Monthly"
        case monthly = "Monthly"
        case annually = "Annually"
    }
}

// Represents a tax obligation on an income stream.
@Model
final class Tax {
    var name: String // e.g., "Federal", "State", "FICA"
    var rate: Double // Stored as a decimal, e.g., 0.22 for 22%
    var incomeStream: IncomeStream?

    init(name: String, rate: Double) {
        self.name = name
        self.rate = rate
    }
}

// Represents an investment account and its anticipated growth.
@Model
final class Investment {
    var accountName: String
    var currentBalance: Double
    var annualGrowthRate: Double // Expected annual growth as a decimal
    var user: User?

    init(accountName: String, currentBalance: Double, annualGrowthRate: Double) {
        self.accountName = accountName
        self.currentBalance = currentBalance
        self.annualGrowthRate = annualGrowthRate
    }
}
