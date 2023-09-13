//
//  NationTimeseriesStruct.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/16/21.
//

import SwiftUI

struct NationwideTimeseries: Hashable, Codable {
    var oneDays: String
    var twoDays: String
    var threeDays: String
    var fourDays: String
    var fiveDays: String
    var sixDays: String
    var sevenDays: String
    
    var oneCases: Int
    var twoCases: Int
    var threeCases: Int
    var fourCases: Int
    var fiveCases: Int
    var sixCases: Int
    var sevenCases: Int
    
    var oneDeaths: Int
    var twoDeaths: Int
    var threeDeaths: Int
    var fourDeaths: Int
    var fiveDeaths: Int
    var sixDeaths: Int
    var sevenDeaths: Int
    
    var oneRecovered: Int
    var twoRecovered: Int
    var threeRecovered: Int
    var fourRecovered: Int
    var fiveRecovered: Int
    var sixRecovered: Int
    var sevenRecovered: Int
}
