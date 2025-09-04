//
//  AppState.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 8/31/25.
//

import Foundation
import SwiftUI
import SwiftData

@Observable class AppState {
    var workingBudgetID: PersistentIdentifier? {
        didSet {
            let _ = print("Updated workingBudgetID!")
            if let budgetID = workingBudgetID {
                AppDefaults.saveWorkingBudgetID(budgetID)
            } else {
                AppDefaults.clearWorkingBudgetID()
            }
        }
    }
}
