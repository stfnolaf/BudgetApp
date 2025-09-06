//
//  SwipeableEnvironmentKeys.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 9/6/25.
//

import SwiftUI

private struct SwipeOffsetKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

private struct SwipeTotalWidthKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

extension EnvironmentValues {
    var swipeOffset: CGFloat {
        get { self[SwipeOffsetKey.self] }
        set { self[SwipeOffsetKey.self] = newValue }
    }
    
    var swipeTotalWidth: CGFloat {
        get { self[SwipeTotalWidthKey.self] }
        set { self[SwipeTotalWidthKey.self] = newValue }
    }
}
