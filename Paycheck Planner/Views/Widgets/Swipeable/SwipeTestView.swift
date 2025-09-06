//
//  SwipeTestView.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 9/6/25.
//

import SwiftUI

struct SwipeTestView: View {
    // Sample data for the list
    @State private var items = [
        "Design Review 🎨",
        "Team Lunch RSVP 🍕",
        "Project Update 🚀",
        "Weekly Report 📊",
        "Client Follow-up 📞",
        "Finalize Q3 Budget 💰"
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                // Use a LazyVStack for performance with long lists
                LazyVStack(spacing: 0) {
                    ForEach(items, id: \.self) { item in
                        SwipeableCell(
                            content: {
                                // This is the main, visible content of your cell
                                HStack {
                                    Text(item)
                                        .padding()
                                    Spacer()
                                }
                                .frame(height: 70)
                                // The content itself needs a background to hide the actions underneath
                                .background(Color(UIColor.systemBackground))
                            },
                            actions: {
                                // These are the swipe actions, declared in the order
                                // you want them to appear from left to right.
                                SwipeAction(
                                    systemImage: "flag.fill",
                                    color: .orange
                                ) {
                                    print("Flagging item: \(item)")
                                }
                                
                                SwipeAction(
                                    systemImage: "trash.fill",
                                    color: .red
                                ) {
                                    // Call the delete function when this action is tapped
                                    deleteItem(item: item)
                                }
                            }
                        )
                        // Add a divider between cells
                        Divider()
                    }
                }
            }
            .navigationTitle("My Inbox")
        }
    }
    
    /// Removes an item from the list with a smooth animation.
    private func deleteItem(item: String) {
        withAnimation {
            items.removeAll { $0 == item }
        }
    }
}

// MARK: - Preview Provider
struct SwipeTestView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeTestView()
    }
}
