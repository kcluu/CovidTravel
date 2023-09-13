//
//  StatisticDetails.swift
//  CovidTravel
//
//  Created by James Kim on 4/14/21.
//

import SwiftUI

struct StatisticDetails: View {
    
    // Input Parameter
    let stat: Statistic
    @EnvironmentObject var userData: UserData
    
    
    var body: some View {
        Form {
            
            Section(header: Text("State Location")) {
                Text("\(stat.state), \(stat.country)")
            }
            
            Section(header: Text("Risk Level of State")) {
                HStack {
                    if stat.riskLevel == 0 {
                        Image("low")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40.0)
                    }
                    else if stat.riskLevel == 1 {
                        Image("medium")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40.0)
                    }
                    else if stat.riskLevel == 2 {
                        Image("high")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40.0)
                    }
                    else if stat.riskLevel == 3 {
                        Image("veryhigh")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40.0)
                    }
                    else {
                        Image("severe")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40.0)
                    }
                    Text("Risk Level: \(risk)")
                }
            }
            
            Section(header: Text("Total Population")) {
                Text("\(stat.population)")
            }
            
            
            Section(header: Text("Total Number of Cases")) {
                Text("\(stat.cases)")
            }
            
            Section(header: Text("Total Number of Deaths")) {
                Text("\(stat.deaths)")
            }
            
            Group {
                
                Section(header: Text("Total Number of Positive Tests")) {
                    Text("\(stat.positiveTests)")
                }
                
                Section(header: Text("Total Number of Negative Tests")) {
                    Text("\(stat.negativeTests)")
                }
                
                Section(header: Text("Total Number of New Cases")) {
                    Text("\(stat.newCases)")
                }
                
                Section(header: Text("Total Number of New Deaths")) {
                    Text("\(stat.newDeaths)")
                }
                
                Section(header: Text("Total Number of Vaccinations Completed")) {
                    Text("\(stat.vaccinationsCompleted)")
                }
                
                Section(header: Text("Data Visualization")) {
                    VStack {
                        Text("Pie Chart Based on Total Population of \(stat.population) People in the State of \(stat.state)")
                        PieChart(data: [Double(stat.cases), Double(stat.vaccinationsCompleted), Double(stat.population)], labels: ["Total Cases", "Vaccinated Persons", "Population"], colors: [Color.blue, Color.red, Color.yellow, Color.black, Color.green], borderColor: Color.white)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 330.0)
                    }
                }
                
                
            }
            
        }   // End of Form
        .navigationBarTitle(Text("Statistics of \(stat.state)"), displayMode: .inline)
        
        
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

