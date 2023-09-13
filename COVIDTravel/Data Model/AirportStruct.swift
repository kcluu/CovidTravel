//
//  AirportStruct.swift
//  Covid19
//
//  Created by Yongjae Lim on 4/15/21.
//  Copyright © 2021 Yongjae Lim. All rights reserved.
//

import SwiftUI

struct AirportStruct: Decodable {
    var name: String
    var city: String
    var country: String
    var iata_code: String
    var _geoloc: Map
//    var latitude: Double
//    var longitude: Double
    var links_count: Int
    var objectID: String
}

struct Map: Decodable {
    var lat: Double
    var lng: Double
}

/*
 {
   "name": "Hartsfield Jackson Atlanta Intl",
   "city": "Atlanta",
   "country": "United States",
   "iata_code": "ATL",
   "_geoloc": {
     "lat": 33.636719,
     "lng": -84.428067
   },
   "links_count": 1826,
   "objectID": "3682"
 }
 */
