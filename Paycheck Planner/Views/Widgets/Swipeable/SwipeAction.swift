//
//  SwipeableCellAction.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 9/6/25.
//

import SwiftUI

struct SwipeAction: View {
    @Environment(\.swipeOffset) private var offset: CGFloat
    @Environment(\.swipeTotalWidth) private var totalWidth: CGFloat
    
    let systemImage: String
    let color: Color
    var action: () -> Void
    
    init(systemImage: String, color: Color, action: @escaping () -> Void) {
        self.systemImage = systemImage
        self.color = color
        self.action = action
    }
    
    private let buttonWidth: CGFloat = 70

    var body: some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .named("actions"))
            let index = Int(round(frame.minX / buttonWidth))
            let progress = calculateProgress(for: index)
            
            Button(action: action) {
                Image(systemName: systemImage)
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .frame(width: buttonWidth, height: buttonWidth)
                    .background(color)
                    .clipShape(Circle())
            }
            .scaleEffect(progress)
            .rotationEffect(.degrees(90 * (1 - Double(progress))))
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: progress)
            .frame(width: buttonWidth)
        }
        .frame(width: buttonWidth)
    }
    
    private func calculateProgress(for index: Int) -> CGFloat {
        guard totalWidth > 0 else { return 0 }
        let overallProgress = abs(offset) / totalWidth
        let totalButtons = Int(round(totalWidth / buttonWidth))
        let animationIndex = totalButtons - 1 - index
        let completionThreshold = CGFloat(animationIndex + 1) / CGFloat(totalButtons)
        let buttonProgress = overallProgress / completionThreshold
        return max(0, min(1, buttonProgress))
    }
}
