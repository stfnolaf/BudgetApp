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
    var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
        .modelContainer(container)
    }
    
    init() {
        do {
            container = try ModelContainer(for: Budget.self, Profile.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }
}
