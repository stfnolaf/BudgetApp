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

struct ExpandableSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        Section(header:
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text(title)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                }
            }
            .buttonStyle(.plain)
        ) {
            if isExpanded {
                VStack(alignment: .leading, spacing: 32) {
                    content()
                }
                .padding(.leading)
            }
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
    
    var body: some View {
        Form {
            LabeledContent("Gross Annual Salary") {
                TextField("Gross Annual Salary", value: $income.annualGrossIncome, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            }
            
            Picker("State of Residence", selection: $selectedState) {
                ForEach(usStates, id: \.self) { state in
                    Text(state)
                }
            }
            .pickerStyle(.menu)
            .padding(.vertical, 4)
            
            ExpandableSection(title: "401k Options") {
                PickerWheelSummoner(title: "Pre-Tax Contribution", currentValue: $income.pctContribPreTax401k)
                PickerWheelSummoner(title: "Employer Match", currentValue: $income.pctEmployerMatch401k)
                PickerWheelSummoner(title: "Employer Match Limit", currentValue: $income.pctEmployerMatchMax401k)
            }
            
            ExpandableSection(title: "HSA Options") {
                LabeledContent("Annual Contribution") {
                    TextField("Annual Contribution", value: $income.dollarContribHSA, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
                LabeledContent("Employer Contribution") {
                    TextField("Employer Contribution", value: $income.dollarEmployerContribHSA, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            ExpandableSection(title: "ESPP Options") {
                PickerWheelSummoner(title: "Percent Withheld", currentValue: $income.pctContribESPP)
                PickerWheelSummoner(title: "Discount", currentValue: $income.pctESPPDiscount)
            }
        }
    }
}

struct ProfileView: View {
    @Binding var selectedTab: ContentView.Tab
    
    @Environment(AppState.self) var appState
        
    @State private var showIncomeSelection = false
    
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
                        Text("No income set up yet!")
                        Button(action: {

                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Set Up Income")
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
    let income = Income(name: "AMD Day Job")
    previewAppState.workingIncome = income
    return ProfileView(selectedTab: $selectedTab)
        .environment(previewAppState)
}
