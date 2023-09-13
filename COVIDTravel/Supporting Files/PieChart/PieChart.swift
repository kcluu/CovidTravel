//
//  PieChart.swift
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

struct PieChart: View {
    
    // Data variables indicated on pie chart
    var data: [Double]
    var labels: [String]
    
    // Colors of the pie chart can be customized
    private let colors: [Color]
    private let borderColor: Color
    private let sliceOffset: Double = -.pi / 2 // Slice position offset
    
    // Initialize data and customizeable components
    init(data: [Double], labels: [String], colors: [Color], borderColor: Color) {
        self.data = data
        self.labels = labels
        self.colors = colors
        self.borderColor = borderColor
    }
    
    var body: some View {
        // GeometryReader imported from SwiftUI package
        GeometryReader { geo in
            ZStack(alignment: .center) {
                // For each data, a "slice" is created. (One for data and one behind for border)
                ForEach(0 ..< data.count) { index in
                    PieSlice(startAngle: startAngle(for: index), endAngle: endAngle(for: index))
                        .fill(colors[index % colors.count])
                    
                    PieSlice(startAngle: startAngle(for: index), endAngle: endAngle(for: index))
                        .stroke(borderColor, lineWidth: 1)
                    
                    PieSliceText( // Data annotation on each slice
                        title: "\(labels[index])",
                        description: String(format: "%.0f", data[index])
                    )
                    .offset(textOffset(for: index, in: geo.size))
                    .zIndex(1)
                }
            }
        }
    }
    
    // Function that calculates the start angle of a "slice"
    private func startAngle(for index: Int) -> Double {
        switch index {
        case 0:
            return sliceOffset
        default:
            let ratio: Double = data[..<index].reduce(0.0, +) / data.reduce(0.0, +)
            return sliceOffset + 2 * .pi * ratio
        }
    }
    
    // Function that calculates the end angle of a "slice"
    private func endAngle(for index: Int) -> Double {
        switch index {
        case data.count - 1:
            return sliceOffset + 2 * .pi
        default:
            let ratio: Double = data[..<(index + 1)].reduce(0.0, +) / data.reduce(0.0, +)
            return sliceOffset + 2 * .pi * ratio
        }
    }
    
    // Function that calculates the offset in which the text should be aligned on the "slice"
    private func textOffset(for index: Int, in size: CGSize) -> CGSize {
        let radius = min(size.width, size.height) / 3
        let dataRatio = (2 * data[..<index].reduce(0, +) + data[index]) / (2 * data.reduce(0, +))
        let angle = CGFloat(sliceOffset + 2 * .pi * dataRatio)
        return CGSize(width: radius * cos(angle), height: radius * sin(angle))
    }
}
