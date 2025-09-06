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
    @GestureState private var dragOffset: CGFloat = 0
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
            actionsView(with: horizontalOffset)
                .zIndex(0)

            contentView
                .offset(x: horizontalOffset)
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
        .environment(\.swipeOffset, horizontalOffset)
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
            .updating($dragOffset) { value, state, _ in
                state = value.translation.width
            }
            .onEnded { value in
                let finalOffset = horizontalOffset + value.translation.width
                let velocityX = value.predictedEndLocation.x - value.location.x
                if finalOffset < -actionsWidth / 2 || velocityX < -50 {
                    openCell()
                } else {
                    closeCell()
                }
            }
    }
    
    private func openCell() {
        withAnimation(.spring()) {
            horizontalOffset = -actionsWidth
        }
        NotificationCenter.default.post(name: .swipeableCellDidOpen, object: id)
    }

    private func closeCell() {
        withAnimation(.spring()) {
            horizontalOffset = 0
        }
    }
}

extension NSNotification.Name {
    static let swipeableCellDidOpen = NSNotification.Name("swipeableCellDidOpen")
}
