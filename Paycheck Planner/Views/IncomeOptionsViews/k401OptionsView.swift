//
//  k401OptionsView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 8/3/25.
//

import SwiftUI

struct k401OptionsView: View {
    @Bindable var income: Income
    var body: some View {
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
}

#Preview {
    //k401OptionsView()
}
