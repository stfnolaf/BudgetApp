import SwiftUI
import SwiftData

struct NewBudgetItemView: View {
    let user: User
    let budget: Budget
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
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
                        ForEach(user.expenseCategories.sorted(by: {$0.name < $1.name}), id: \.self) {category in
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
                        saveBudgetItem()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || amount <= 0)
                }
            }
        }
    }

    private func saveBudgetItem() {
        let newBudgetItem = BudgetItem(
            name: name,
            amount: amount,
            category: selectedCategory,
            frequency: selectedFrequency
        )
        
        newBudgetItem.budget = budget
        
        modelContext.insert(newBudgetItem)
        dismiss()
    }
}

#Preview {
    let budget = Budget.forPreview
    let user = budget.user!
    return NewBudgetItemView(user: user, budget: budget)
}
