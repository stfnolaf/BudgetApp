//
//  RetirementPlan.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 8/17/25.
//

import Foundation
import SwiftData

// Represents a contribution to a retirement account from an income stream.
@Model
final class RetirementContribution {
    var accountName: String // e.g., "401(k)", "Roth IRA"
    var contributionType: ContributionType
    var amount: Double // Can be a percentage or a flat amount based on the type
    var incomeStream: IncomeStream?

    init(accountName: String, contributionType: ContributionType, amount: Double) {
        self.accountName = accountName
        self.contributionType = contributionType
        self.amount = amount
    }

    // Enum to distinguish between percentage-based and fixed-amount contributions.
    enum ContributionType: String, Codable, CaseIterable {
        case percentage = "Percentage"
        case fixedAmount = "Fixed Amount"
    }
}
