//
//  SettingsView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//

import SwiftUI

struct IncomeEditingView: View {
    let income: Income
    var body: some View {
        Text("Hello World")
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
                                Text("New Income")
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
    var income = Income(name: "My Income")
    previewAppState.workingIncome = income
    return ProfileView(selectedTab: $selectedTab)
        .environment(previewAppState)
}
