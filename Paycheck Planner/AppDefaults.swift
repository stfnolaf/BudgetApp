//
//  AppDefaults.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 8/31/25.
//

import Foundation
import SwiftData

enum AppDefaults {
    private static let lastWorkingBudgetIDKey = "lastWorkingBudgetID"
    
    static func loadWorkingBudgetID() -> PersistentIdentifier? {
        guard let data = UserDefaults.standard.data(forKey: lastWorkingBudgetIDKey) else {
            return nil
        }
        return try? JSONDecoder().decode(PersistentIdentifier.self, from: data)
    }
    
    static func saveWorkingBudgetID(_ id: PersistentIdentifier) {
        do {
            let data = try JSONEncoder().encode(id)
            UserDefaults.standard.setValue(data, forKey: lastWorkingBudgetIDKey)
        } catch {
            print("Failed to save budget ID: \(error)")
        }
    }
    
    static func clearWorkingBudgetID() {
        UserDefaults.standard.removeObject(forKey: lastWorkingBudgetIDKey)
    }
}
