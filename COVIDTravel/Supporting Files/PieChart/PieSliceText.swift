//
//  PieSliceText.swift
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

// Data displayed in text on each slice of the pie
struct PieSliceText: View {
    // Title and description/data
    let title: String
    let description: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 14))
            Text(description)
                .font(.system(size: 12))
        }
    }
}
