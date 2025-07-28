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

    var pctContribPreTax401k: Double
    var pctContribAfterTax401k: Double
    var pctContribRoth401k: Double
    var pctEmployerMatch401k: Double
    var pctEmployerMatchMax401k: Double

    var dollarContribHSA: Double
    var dollarEmployerContribHSA: Double

    var dollarMiscPreTaxDeductions: Double

    var pctContribESPP: Double
    var pctESPPDiscount: Double

    init(
        _ name: String,
        id: UUID = UUID(),
        annualGrossIncome: Double = 0.0,
        pctContribPreTax401k: Double = 0.0,
        pctContribAfterTax401k: Double = 0.0,
        pctContribRoth401k: Double = 0.0,
        pctEmployerMatch401k: Double = 0.0,
        pctEmployerMatchMax401k: Double = 0.0,
        dollarContribHSA: Double = 0.0,
        dollarEmployerContribHSA: Double = 0.0,
        dollarMiscPreTaxDeductions: Double = 0.0,
        pctContribESPP: Double = 0.0,
        pctESPPDiscount: Double = 0.0
    ) {
        self.id = id
        self.name = name
        self.annualGrossIncome = annualGrossIncome
        self.pctContribPreTax401k = pctContribPreTax401k
        self.pctContribAfterTax401k = pctContribAfterTax401k
        self.pctContribRoth401k = pctContribRoth401k
        self.pctEmployerMatch401k = pctEmployerMatch401k
        self.pctEmployerMatchMax401k = pctEmployerMatchMax401k
        self.dollarContribHSA = dollarContribHSA
        self.dollarEmployerContribHSA = dollarEmployerContribHSA
        self.dollarMiscPreTaxDeductions = dollarMiscPreTaxDeductions
        self.pctContribESPP = pctContribESPP
        self.pctESPPDiscount = pctESPPDiscount
    }
}
