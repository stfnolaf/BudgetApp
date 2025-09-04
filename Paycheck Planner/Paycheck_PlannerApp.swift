//
//  Paycheck_PlannerApp.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//

import SwiftUI
import SwiftData

@main
struct Paycheck_PlannerApp: App {
    
    
    @State private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
        .modelContainer(for: [Budget.self, Expense.self])
    }
}
