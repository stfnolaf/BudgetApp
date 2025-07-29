//
//  UserInfo.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//
import Foundation
import SwiftData

@Model
final class Income {
    @Attribute(.unique) var id: UUID
    
    var name: String
    
    var annualGrossIncome: Double
    
    var k401_preTaxContribution: Double
    var k401_afterTaxContribution: Double
    var k401_rothContribution: Double
    var k401_employerMatch: Double
    var k401_employerMatchLimit: Double
    
    var espp_employeeContribution: Double
    var espp_employerDiscount: Double
    var espp_contributionLimit: Double
    
    var hsa_employeeContribTarget: Double
    var hsa_employerContribution: Double

    init(
        _ name: String,
        id: UUID = UUID(),
        annualGrossIncome: Double = 0.0,
        
        k401_preTaxContribution: Double = 0.0,
        k401_afterTaxContribution: Double = 0.0,
        k401_rothContribution: Double = 0.0,
        k401_employerMatch: Double = 0.0,
        k401_employerMatchLimit: Double = 0.0,
        
        espp_employeeContribution: Double = 0.0,
        espp_employerDiscount: Double = 0.0,
        espp_contributionLimit: Double = 0.0,
        
        hsa_employeeContribTarget: Double = 0.0,
        hsa_employerContribution: Double = 0.0
    ) {
        self.id = id
        self.name = name
        self.annualGrossIncome = annualGrossIncome
        
        self.k401_preTaxContribution = k401_preTaxContribution
        self.k401_afterTaxContribution = k401_afterTaxContribution
        self.k401_rothContribution = k401_rothContribution
        self.k401_employerMatch = k401_employerMatch
        self.k401_employerMatchLimit = k401_employerMatchLimit
        
        self.espp_employeeContribution = espp_employeeContribution
        self.espp_employerDiscount = espp_employerDiscount
        self.espp_contributionLimit = espp_contributionLimit
        
        self.hsa_employeeContribTarget = hsa_employeeContribTarget
        self.hsa_employerContribution = hsa_employerContribution
    }
}
