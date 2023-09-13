//
//  PieSlice.swift
//  CovidTravel
//
//  Created by James Kim on 4/20/21.
//  Copyright © 2021 James Kim. All rights reserved.
//

import SwiftUI

// Implementation of Pie Chart with help from:
// https://towardsdatascience.com/data-visualization-with-swiftui-pie-charts-bcad1903c5d2
// https://gist.github.com/JimmyMAndersson
// By Jimmy M Andersson

// "Slice" of a pie
struct PieSlice: Shape {
    // Start and end angles input parameters
    let startAngle: Double
    let endAngle: Double
    
    // Function that tailors the shape of the pie slice
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        let radius = min(rect.width, rect.height) / 2
        let alpha = CGFloat(startAngle)
        // Center point of the pie
        let center = CGPoint(
            x: rect.midX,
            y: rect.midY
        )
        
        path.move(to: center)
        
        path.addLine(
            to: CGPoint(
                x: center.x + cos(alpha) * radius,
                y: center.y + sin(alpha) * radius
            )
        )
        // Calculate the arc of the slice based on start and end angles
        path.addArc(
            center: center,
            radius: radius,
            startAngle: Angle(radians: startAngle),
            endAngle: Angle(radians: endAngle),
            clockwise: false
        )
        
        path.closeSubpath()
        
        return path
    }
}
