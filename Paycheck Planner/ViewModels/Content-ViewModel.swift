//
//  AppViewModel.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/9/25.
//

import Foundation
import SwiftData
import SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        private(set) var expenseLists = [Budget]()
        private static let lastExpenseListKey = "LastExpenseListID"
        private var _selectedExpenseList: Budget?
        
        var selectedExpenseList: Budget? {
            get { _selectedExpenseList }
            set {
                _selectedExpenseList = newValue
                saveLastExpenseListID(newValue?.id)
            }
        }
        
        private func saveLastExpenseListID(_ id: UUID?) {
            UserDefaults.standard.set(id?.uuidString, forKey: Self.lastExpenseListKey)
        }
        private static func loadLastSelectedBudgetID() -> UUID? {
            guard let string = UserDefaults.standard.string(forKey: Self.lastExpenseListKey) else { return nil }
            return UUID(uuidString: string)
        }
        
        private func loadLastSelectedBudget() {
            if let lastID = Self.loadLastSelectedBudgetID(), let found = self.expenseLists.first(where: { $0.id == lastID }) {
                self.selectedExpenseList = found
            } else {
                self.selectedExpenseList = nil
            }
        }
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchExpenseLists()
            loadLastSelectedBudget()
        }
        
        func addExpenseList(_ expenses: Budget) {
            modelContext.insert(expenses)
            do {
                try modelContext.save()
                fetchExpenseLists()
                validateSelectedBudget()
            } catch {
                print("Failed to save budget: \(error)")
            }
        }
        
        func addExpense(_ expense: Expense) {
            guard let list = selectedExpenseList else { return }
            list.expenses.append(expense)
            modelContext.insert(expense)
            try? modelContext.save()
            fetchExpenseLists()
        }
        
        func fetchExpenseLists() {
            do {
                let descriptor = FetchDescriptor<Budget>(sortBy: [SortDescriptor(\.name)])
                self.expenseLists = try modelContext.fetch(descriptor)
                validateSelectedBudget()
            } catch {
                print("Failed to fetch income info:", error)
                self.expenseLists = []
            }
        }
        
        private func validateSelectedBudget() {
            if let selected = selectedExpenseList, !expenseLists.contains(where: { $0.id == selected.id }) {
                selectedExpenseList = nil
            }
        }
    }
}
