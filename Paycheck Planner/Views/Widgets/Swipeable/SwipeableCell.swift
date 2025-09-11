//
//  SwipeableCell.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 9/5/25.
//

import SwiftUI

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

struct SwipeableCell<Content: View>: View {
    let content: Content
    let actions: [SwipeAction]
    
    @State private var cellPosition: CGFloat = 0
    @State private var dragStartLocation: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
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
            let offset = (cellPosition + dragOffset).clamped(to: -actionsWidth...0)
            
            actionsView(with: offset)
                .zIndex(0)

            contentView
                .offset(x: offset)
                .gesture(dragGesture)
                .zIndex(1)
        }
        .onReceive(NotificationCenter.default.publisher(for: .swipeableCellDidOpen)) { notification in
            if let openedCellID = notification.object as? UUID, id != openedCellID {
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
                    actionsWidth = geometry.size.width
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
                closeCell()
            }
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onChanged() { value in
                if dragStartLocation == 0 {
                    dragStartLocation = value.translation.width
                }
                dragOffset = value.translation.width - dragStartLocation
            }
            .onEnded { value in
                let velocityX = value.predictedEndLocation.x - value.location.x
                let velocityThreshold = 50.0
                if abs(velocityX) > velocityThreshold {
                    if velocityX < 0 {
                        openCell()
                    } else if velocityX > 0 {
                        closeCell()
                    }
                } else {
                    if cellPosition + dragOffset < -actionsWidth / 2 {
                        openCell()
                    } else {
                        closeCell()
                    }
                }
                dragOffset = 0
                dragStartLocation = 0
            }
    }
    
    private func openCell() {
        NotificationCenter.default.post(name: .swipeableCellDidOpen, object: id)
        withTransaction(Transaction(animation: .easeOut(duration: 0.3))) {
            cellPosition = -actionsWidth
        }
    }

    private func closeCell() {
        withTransaction(Transaction(animation: .easeOut(duration: 0.3))) {
            cellPosition = 0
        }
    }
}

extension NSNotification.Name {
    static let swipeableCellDidOpen = NSNotification.Name("swipeableCellDidOpen")
}
