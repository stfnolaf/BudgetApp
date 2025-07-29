//
//  SettingsView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//

import SwiftUI
import SwiftData

struct PickerWheelSummoner: View {
    let title: String
    @Binding var currentValue: Double
    @State private var isShowingPicker = false
    var body: some View {
        Button(action: { isShowingPicker = true }) {
            HStack {
                Text(title)
                    .foregroundStyle(.primary)
                Spacer()
                Text(String(format: "%.0f%%", currentValue * 100))
                    .foregroundStyle(.selection)
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isShowingPicker) {
            VStack {
                Text("Select \(title)")
                    .font(.headline)
                    .padding()
                Picker(title, selection: $currentValue) {
                    ForEach(0..<101) { pct in
                        Text("\(pct)%").tag(Double(pct) / 100.0)
                    }
                }
                .pickerStyle(.wheel)
                .labelsHidden()
                Button("Done") {
                    isShowingPicker = false
                }
                .padding()
            }
            .presentationDetents([.medium, .large])
        }
    }
}

struct IncomeEditingView: View {
    @Bindable var income: Income
    
    @State private var selectedState: String = "CA" // default to California
    let usStates = [
        "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
        "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
        "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
        "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
        "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"
    ]
    
    private var k401Form: some View {
        Form {
            Section(header: Text("Employee Settings")
                .font(.caption)
                .foregroundColor(.secondary)
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    PickerWheelSummoner(title: "Pre-Tax", currentValue: $income.k401_preTaxContribution)
                    Divider()
                    PickerWheelSummoner(title: "After-Tax", currentValue: $income.k401_afterTaxContribution)
                    Divider()
                    PickerWheelSummoner(title: "Roth", currentValue: $income.k401_rothContribution)
                }
                .padding(.leading)
            }
            Section(header: Text("Employer Settings")
                .font(.caption)
                .foregroundColor(.secondary)
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    PickerWheelSummoner(title: "Match", currentValue: $income.k401_employerMatch)
                    Divider()
                    PickerWheelSummoner(title: "Match Limit", currentValue: $income.k401_employerMatchLimit)
                }
                .padding(.leading)
            }
        }
    }
    
    private var hsaForm: some View {
        Form {
            Section(header: Text("Employee Settings")
                .font(.caption)
                .foregroundColor(.secondary)
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    LabeledContent("Annual Contribution") {
                        TextField("Employee Annual Contribution", value: $income.hsa_employeeContribTarget, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 100)
                    }
                }
                .padding(.leading)
            }
            Section(header: Text("Employer Settings")
                .font(.caption)
                .foregroundColor(.secondary)
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    LabeledContent("Annual Contribution") {
                        TextField("Employer Annual Contribution", value: $income.hsa_employerContribution, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 100)
                    }
                }
                .padding(.leading)
            }
        }
    }
    
    private var esppForm: some View {
        Form {
            Section(header: Text("Employee Settings")
                .font(.caption)
                .foregroundColor(.secondary)
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    PickerWheelSummoner(title: "Percent Withheld", currentValue: $income.espp_employeeContribution)
                }
                .padding(.leading)
            }
            Section(header:
                        Text("Employer Settings")
                .font(.caption)
                .foregroundColor(.secondary)
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    PickerWheelSummoner(title: "Discount", currentValue: $income.espp_employerDiscount)
                    Divider()
                    LabeledContent("Contribution Limit") {
                        TextField("Contribution Limit", value: $income.espp_contributionLimit, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 100)
                    }
                }
                .padding(.leading)
            }
        }
    }
    
    var body: some View {
        Form {
            LabeledContent("Gross Annual Salary") {
                TextField("Gross Annual Salary", value: $income.annualGrossIncome, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 100)
            }
            
            Picker("State of Residence", selection: $selectedState) {
                ForEach(usStates, id: \.self) { state in
                    Text(state)
                }
            }
            .pickerStyle(.menu)
            
            Section("Retirement Accounts") {
                
                NavigationLink("401k") {
                    k401Form
                }
                
                NavigationLink("HSA") {
                    hsaForm
                }
                
            }
            
            Section("Other Deductions") {
                NavigationLink("ESPP") {
                    esppForm
                }
                
                NavigationLink("Misc") {
                    
                }
            }
        }
    }
}

struct PaycheckView: View {
    @Binding var selectedTab: ContentView.Tab
    
    @Environment(AppState.self) var appState
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(appState.workingIncome?.name ?? "")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .horizontal])
                    Spacer()
                    NavigationLink(destination: IncomeSelectionView()) {
                        Image(systemName: "list.bullet")
                    }
                    .padding([.top, .horizontal])
                }
                Spacer()
                if let income = appState.workingIncome {
                    IncomeEditingView(income: income)
                } else {
                    VStack {
                        Text("No paycheck set up yet!")
                        Button(action: {

                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("New Paycheck")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor.opacity(0.15))
                            .cornerRadius(12)
                        }
                        .padding()
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedTab: ContentView.Tab = .budget
    let previewAppState = AppState()
    let income = Income("AMD Day Job")
    previewAppState.workingIncome = income
    return PaycheckView(selectedTab: $selectedTab)
        .environment(previewAppState)
}

