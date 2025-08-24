//
//  PickerWheelSummoner.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 8/17/25.
//

import SwiftUI

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
