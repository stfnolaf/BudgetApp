//
//  AppState.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/17/25.
//

import Foundation
import SwiftData

@Observable
final class AppState {
    var userProfile: Profile!
    var workingBudget: Budget?
}
