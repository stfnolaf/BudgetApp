import SwiftUI
import SwiftData

struct NewExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    
    let expenseCategories: [String]

    @State private var title: String = ""
    @State private var amount: Double = 0.0
    @State private var selectedCategory: String = "Utilities"
    @State private var selectedFrequency: Frequency = .monthly
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Title", text: $title)
                    TextField("Amount", value: $amount, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(expenseCategories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    Picker("Frequency", selection: $selectedFrequency) {
                        ForEach(Frequency.allCases, id: \.self) { freq in
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
        let newExpense = Expense(
            category: selectedCategory,
            amount: amount,
            title: title,
            frequency: selectedFrequency
        )
        // TODO: add newExpense to model context
        dismiss()
    }
}

#Preview {
    NewExpenseView(expenseCategories: ["Rent", "Utilities", "Transportation", "Insurance", "Groceries", "Splurge", "Smile"])
}
