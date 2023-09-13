//
//  StatisticStruct.swift
//  CovidTravel
//
//  Created by James Kim on 4/14/21.
//

import SwiftUI
 
public struct Statistic: Hashable, Codable, Identifiable {
   
    public var id: UUID
    var country: String
    var state: String
    var fullState: String
    var population: Int
    var riskLevel: Int
    var cases: Int
    var deaths: Int
    var positiveTests: Int
    var negativeTests: Int
    var newCases: Int
    var newDeaths: Int
    var vaccinesDistributed: Int
    var vaccinationsInitiated: Int
    var vaccinationsCompleted: Int
    var vaccinesAdministered: Int
    
    
}
