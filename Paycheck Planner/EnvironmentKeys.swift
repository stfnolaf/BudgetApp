//
//  EnvironmentKeys.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 8/24/25.
//

// In a new file: EnvironmentKeys.swift

import SwiftUI
import SwiftData

// Key for the working budget
struct WorkingBudgetKey: EnvironmentKey {
    static let defaultValue: Binding<Budget?> = .constant(nil)
}

struct CurrentUserKey: EnvironmentKey {
    static let defaultValue: User? = nil
}

extension EnvironmentValues {
    var workingBudget: Binding<Budget?> {
        get { self[WorkingBudgetKey.self] }
        set { self[WorkingBudgetKey.self] = newValue }
    }
    var currentUser: User? {
        get { self[CurrentUserKey.self] }
        set { self[CurrentUserKey.self] = newValue }
    }
}
