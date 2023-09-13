//
//  StatisticItem.swift
//  CovidTravel
//
//  Created by James Kim on 4/14/21.
//

import SwiftUI

struct StatisticItem: View {
   
    // Input Parameter
    let stat: Statistic
   
    var body: some View {
        HStack {
            
            if stat.riskLevel == 0 {
                Image("low")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70.0)
            }
            else if stat.riskLevel == 1 {
                Image("medium")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70.0)
            }
            else if stat.riskLevel == 2 {
                Image("high")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70.0)
            }
            else if stat.riskLevel == 3 {
                Image("veryhigh")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70.0)
            }
            else {
                Image("severe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70.0)
            }
 
            VStack(alignment: .leading) {
                Text("State: \(stat.fullState) [\(stat.state)]")
                Text("Total Population: \(stat.population)")
                Text("Total Covid-19 Cases: \(stat.cases)")
                Text("Total Positive Tests: \(stat.positiveTests)")
            }
            .font(.system(size: 14))
        }
        
        
    }
    
    var risk: String {
        if stat.riskLevel == 0 {
            return "Low"
        }
        else if stat.riskLevel == 1 {
            return "Medium"
        }
        else if stat.riskLevel == 2 {
            return "High"
        }
        else if stat.riskLevel == 3 {
            return "High"
        }
        else {
            return "Severe"
        }
        
    }
}

