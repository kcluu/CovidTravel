//
//  VaccineStruct.swift
//  CovidTravel
//
//  Created by James Kim on 4/19/21.
//  Copyright © 2021 James Kim. All rights reserved.
//

import SwiftUI
 
public struct Vaccine: Hashable, Codable, Identifiable {
   
    public var id: String
    var latitude: Double
    var longitude: Double
    var url: String
    var city: String
    var state: String
    var address: String
    var hasVaccine: Bool
    var providerName: String
    var appointmentsAvailable: Bool
    var vaccineType: String
    
}
