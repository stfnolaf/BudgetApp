//
//  SwipeableCell.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 9/5/25.
//

import SwiftUI

struct SwipeableCell<Content: View>: View {
    let content: Content
    let actions: [SwipeAction]
    
    @State private var horizontalOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isOpen: Bool = false
    @State private var actionsWidth: CGFloat = 0
        
    init(
        @ViewBuilder content: () -> Content,
        @SwipeActionBuilder actions: () -> [SwipeAction],
    ) {
        self.content = content()
        self.actions = actions()
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            actionsView(with: horizontalOffset + dragOffset)
                .zIndex(0)

            contentView
                .offset(x: horizontalOffset + dragOffset)
                .gesture(dragGesture)
                .zIndex(1)
        }
        .onReceive(NotificationCenter.default.publisher(for: .swipeableCellDidOpen)) { notification in
            if let openedCellID = notification.object as? UUID, self.id != openedCellID {
                closeCell()
            }
        }
    }

    private let id = UUID()
    
    private func actionsView(with offset: CGFloat) -> some View {
        HStack(spacing: 5) {
            ForEach(actions.indices, id: \.self) { index in
                actions[index]
            }
        }
        .padding(.horizontal, 10)
        .coordinateSpace(name: "actions")
        .background(
            GeometryReader { geometry in
                Color.clear.onAppear {
                    self.actionsWidth = geometry.size.width
                }
            }
        )
        .environment(\.swipeOffset, offset)
        .environment(\.swipeTotalWidth, actionsWidth)
    }
    
    private var contentView: some View {
        content
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .onTapGesture {
                if horizontalOffset != 0 {
                    closeCell()
                }
            }
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onChanged { value in
                let targetOffset = value.translation.width
                let currentOffset = self.dragOffset
                
                let lagFactor: CGFloat = 0.7
                
                // Apply linear interpolation to smoothly move towards the target.
                var newDragOffset = currentOffset + (targetOffset - currentOffset) * lagFactor

                // --- ADDED: Clamp the motion to prevent dragging to the right ---
                // Calculate the potential total visual offset
                let potentialTotalOffset = self.horizontalOffset + newDragOffset
                
                // If the cell tries to move to the right of its resting position (0),
                // correct the drag offset to prevent it.
                if potentialTotalOffset > 0 {
                    newDragOffset = -self.horizontalOffset
                }
                
                self.dragOffset = newDragOffset
            }
            .onEnded { value in
                // Decision logic should use the raw finger position, not the smoothed one.
                let finalRawOffset = self.horizontalOffset + value.translation.width
                let velocityX = value.predictedEndLocation.x - value.location.x
                
                // Commit the final smoothed visual position to the permanent state.
                self.horizontalOffset += self.dragOffset
                // Reset the transient drag offset for the next gesture.
                self.dragOffset = 0
                
                if !self.isOpen {
                    if finalRawOffset < -self.actionsWidth / 2 || velocityX < -50 {
                        self.openCell()
                    } else {
                        self.closeCell()
                    }
                } else {
                    if finalRawOffset > -self.actionsWidth / 2 || velocityX > 50 {
                        self.closeCell()
                    } else {
                        self.openCell()
                    }
                }
            }
    }
    
    private func openCell() {
        self.isOpen = true
        withAnimation(.smooth()) {
            horizontalOffset = -actionsWidth
        }
        NotificationCenter.default.post(name: .swipeableCellDidOpen, object: id)
    }

    private func closeCell() {
        self.isOpen = false
        withAnimation(.smooth()) {
            horizontalOffset = 0
        }
    }
}

extension NSNotification.Name {
    static let swipeableCellDidOpen = NSNotification.Name("swipeableCellDidOpen")
}
