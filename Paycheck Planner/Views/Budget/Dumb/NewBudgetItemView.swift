import SwiftUI
import SwiftData

struct NewBudgetItemView: View {
    // Inputs
    let budget: Budget
    let categories: [ExpenseCategory]
    let onCreate: (String, Budget, ExpenseCategory, Double, BudgetItem.BudgetFrequency) -> Void
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // States
    @State private var name: String = ""
    @State private var amount: Double = 0.0
    @State private var selectedCategory: ExpenseCategory? = nil
    @State private var selectedFrequency: BudgetItem.BudgetFrequency = .monthly
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Expense Details") {
                    TextField("Name (e.g. Rent, Gas)", text: $name)
                    TextField("Amount", value: $amount, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                    Picker("Frequency", selection: $selectedFrequency) {
                        ForEach(BudgetItem.BudgetFrequency.allCases, id: \.self) { freq in
                            Text(freq.rawValue).tag(freq)
                        }
                    }
                }
                Section("Category") {
                    Picker("Select a Category", selection: $selectedCategory) {
                        Text("None").tag(nil as ExpenseCategory?)
                        ForEach(categories.sorted(by: {$0.name < $1.name}), id: \.self) {category in
                            Text(category.name).tag(category as ExpenseCategory?)
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onCreate(name, budget, selectedCategory!, amount, selectedFrequency)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || amount <= 0 || selectedCategory == nil)
                }
            }
        }
    }
}

#Preview {
    ({
        let budget = Budget.forPreview
        var categories: [ExpenseCategory] = []
        for item in budget.items {
            if !categories.contains(where: { $0 == item.category }) {
                categories.append(item.category)
            }
        }
        return NewBudgetItemView(budget: budget, categories: categories, onCreate: { name, budget, category, amount, frequency in })
    })()
}
