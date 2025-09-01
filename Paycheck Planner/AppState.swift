//
//  AppState.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 8/31/25.
//

import Foundation
import SwiftUI

@Observable class AppState {
    @ObservationIgnored private var _workingBudget: Budget? = nil
    var workingBudget: Budget? {
        set {
            _workingBudget = newValue
            if let budget = newValue {
                AppDefaults.saveWorkingBudgetID(budget.id)
            } else {
                AppDefaults.clearWorkingBudgetID()
            }
        }
        get {
            return _workingBudget
        }
    }
}
