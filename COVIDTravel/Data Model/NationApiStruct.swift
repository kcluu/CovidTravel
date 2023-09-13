//
//  NationApiStruct.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/16/21.
//

import SwiftUI

struct NationApi: Hashable, Codable, Identifiable {
    var id: UUID
    var cases: Int
    var todayCases: Int
    var deaths: Int
    var todayDeaths: Int
    var active: Int
}

