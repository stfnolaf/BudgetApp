//
//  UserInfo.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//
import Foundation
import SwiftData

protocol IncomeProtocol {
    var grossIncome: Double { get }
    var frequency: Frequency { get }
}

func convertIncomeRate(amount: Double, per: Frequency, to: Frequency) -> Double {
    // TODO
    return 0
}

enum IncomeType: String, Codable, CaseIterable, Identifiable {
    case salary
    case freelance
    case rental
    case business	
    case pension
    case socialSecurity
    case alimonyChildSupport
    case governmentBenefits
    case other
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .salary: return "Salary"
        case .freelance: return "Freelance"
        case .rental: return "Rental"
        case .business: return "Business"
        case .pension: return "Pension"
        case .socialSecurity: return "Social Security"
        case .alimonyChildSupport: return "Alimony/Child Support"
        case .governmentBenefits: return "Government Benefits"
        case .other: return "Other"
        }
    }
}

@Model
final class Profile {
    @Attribute(.unique) var id: UUID
    @Relationship var incomeSources: [IncomeSource]
    @Relationship var individualRetirementPlans: [RetirementPlanDetails]
        
    init(id: UUID = UUID(), incomeSources: [IncomeSource] = [], retirementPlans: [RetirementPlanDetails] = []) {
        self.id = id
        self.incomeSources = incomeSources
        self.individualRetirementPlans = retirementPlans
    }
}

@Model
final class EsppOptions {
    var contributionPct: Double
    var discountPct: Double
    var periodMonths: Int
    var sellOnVest: Bool
    
    init(contributionPct: Double = 0.0, discountPct: Double = 0.0, periodMonths: Int = 6, sellOnVest: Bool = false) {
        self.contributionPct = contributionPct
        self.discountPct = discountPct
        self.periodMonths = periodMonths
        self.sellOnVest = sellOnVest
    }
}

@Model
final class SalaryDetails: IncomeProtocol {
    var annualSalary: Double
    var annualEquity: Double
    var grossIncome: Double {
        get {
            return annualSalary + annualEquity
        }
    }
    var frequency: Frequency
    @Relationship var employerRetirementPlans: [RetirementPlanDetails]
    @Relationship var esppOptions: EsppOptions
    
    init(annualSalary: Double, annualEquity: Double = 0.0, frequency: Frequency = .annually, employerRetirementPlans: [RetirementPlanDetails] = [], espp: EsppOptions = EsppOptions()) {
        self.annualSalary = annualSalary
        self.annualEquity = annualEquity
        self.frequency = frequency
        self.employerRetirementPlans = employerRetirementPlans
        self.esppOptions = espp
    }
}

@Model
final class IncomeSource {
    @Attribute(.unique) var id: UUID
    
    var name: String
    var type: IncomeType
    var expiryDate: Date?
    
    @Relationship var salary: SalaryDetails?

    init(
        _ name: String,
        type: IncomeType,
        id: UUID = UUID(),
        annualGrossIncome: Double = 0.0,
        expiryDate: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.expiryDate = expiryDate
    }
}

@Model
final class RetirementPlanDetails {
    var planType: String // e.g., "401k", "403b", etc.
    var preTaxContribution: Double
    var rothContribution: Double
    var afterTaxContribution: Double
    var employerMatch: Double
    var employerMatchLimit: Double

    init(
        planType: String,
        preTaxContribution: Double = 0,
        rothContribution: Double = 0,
        afterTaxContribution: Double = 0,
        employerMatch: Double = 0,
        employerMatchLimit: Double = 0
    ) {
        self.planType = planType
        self.preTaxContribution = preTaxContribution
        self.rothContribution = rothContribution
        self.afterTaxContribution = afterTaxContribution
        self.employerMatch = employerMatch
        self.employerMatchLimit = employerMatchLimit
    }
}
