//
//  StateTimeseriesStruct.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/14/21.
//

import SwiftUI

struct StateTimeseries: Hashable, Codable, Identifiable {
    var id: UUID
    var country: String
    var state: String
    var cases: Int
    var deaths: Int
    var positiveTests: Int
    var negativeTests: Int
    var newCases: Int
    var newDeaths: Int
    var date: String
}
