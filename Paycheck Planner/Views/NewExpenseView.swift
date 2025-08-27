import SwiftUI
import SwiftData

struct NewExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.workingBudget) private var workingBudget
    
    @State private var title: String = ""
    @State private var amount: Double = 0.0
    @State private var selectedCategory: ExpenseCategory? = nil
    @State private var selectedFrequency: BudgetItem.BudgetFrequency = .monthly
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Title", text: $title)
                    TextField("Amount", value: $amount, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(workingBudget.wrappedValue!.expenseCategories.sorted(by: { $0.name > $1.name }), id: \.self) { category in
                            Text(category.name).tag(category)
                        }
                    }
                    Picker("Frequency", selection: $selectedFrequency) {
                        ForEach(BudgetItem.BudgetFrequency.allCases, id: \.self) { freq in
                            Text(freq.rawValue).tag(freq)
                        }
                    }
                }
                if let errorMessage = errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("New Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addExpense()
                    }
                    .disabled(title.isEmpty || amount <= 0)
                }
            }
        }
    }

    private func addExpense() {
        guard amount >= 0 else {
            errorMessage = "Please enter a valid amount."
            return
        }
        guard let cat = selectedCategory else {
            errorMessage = "Please select a category."
            return
        }
        let newExpense = BudgetItem(
            name: title,
            amount: amount,
            category: cat,
            frequency: selectedFrequency
        )
        // TODO: add newExpense to model context
        dismiss()
    }
}

#Preview {
    NewExpenseView()
}
