//
//  PlannedFlightStruct.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/29/21.
//

import Foundation

struct PlannedFlight: Decodable {
    
    var airlineName: String
    var departureCode: String
    var departureDateTime: String
    var cost: Double
    var arrivalCode: String
    var arrivalDateTime: String
    var notes: String
    var purpose: String
    var photoFullFilename: String
    var airlineWebsite: String
}

/*
 {
   "airlineName": "jetBlue",
   "departureCode": "DCA",
   "departureDateTime": "2021-07-22 at 08:00:00",
   "cost": 179.00,
   "arrivalCode": "BOS",
   "arrivalDateTime": "2021-07-22 at 09:30:00",
   "notes": "Remember to pack laptop, laptop charter, and phone charger. Bring business folder with paperwork.",
   "purpose": "Business trip",
   "photoFullFilename": "EmmasBoardingPass.jpg",
   "airlineWebsite": "https://www.jetblue.com/"
 }
 */
