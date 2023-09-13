//
//  StateApiStruct.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/15/21.
//

import SwiftUI

struct StateApi: Hashable, Codable, Identifiable {
    var id: UUID
    var country: String
    var state: String
    var overall: Int
    var cases: Int
    var deaths: Int
    var positiveTests: Int
    var negativeTests: Int
    var newCases: Int
    var newDeaths: Int
    var vaccinesDistributed: Int
    var vaccinationsInitiated: Int
    var vaccinationsCompleted: Int
    var vaccinationsAdministered: Int
}
