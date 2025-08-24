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
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
    
    init() {
        do {
            let schema = Schema([
                User.self,
                IncomeStream.self,
                Tax.self,
                RetirementContribution.self,
                Expense.self,
                Budget.self,
                BudgetItem.self,
                Investment.self
            ])
            
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
                container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }
}
