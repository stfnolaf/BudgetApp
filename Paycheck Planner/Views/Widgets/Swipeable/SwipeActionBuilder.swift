//
//  SwipeActionBuilder.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 9/6/25.
//

@resultBuilder
struct SwipeActionBuilder {
    static func buildBlock(_ components: SwipeAction...) -> [SwipeAction] {
        return components
    }
}
