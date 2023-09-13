//
//  NationwideApiData.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/16/21.
//

import SwiftUI

var nationwideData = NationApi(id: UUID(), cases: 0, todayCases: 0, deaths: 0, todayDeaths: 0, active: 0)
public func getNationwideDataFromApi() {
    let nationwideDataApiUrl = "https://corona.lmao.ninja/v2/countries/USA"
    // The function is given in ApiData.swift
    let jsonDataFromApi = getJsonDataFromApi(apiUrl: nationwideDataApiUrl)

    //------------------------------------------------
    // JSON data is obtained from the API. Process it.
    //------------------------------------------------

    do {
        /*
        Foundation framework’s JSONSerialization class is used to convert JSON data
        into Swift data types such as Dictionary, Array, String, Number, or Bool.
        */
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi!,
                         options: JSONSerialization.ReadingOptions.mutableContainers)
        /*
        JSON object with Attribute-Value pairs corresponds to Swift Dictionary type with
        Key-Value pairs. Therefore, we use a Dictionary to represent a JSON object
        where Dictionary Key type is String and Value type is Any (instance of any type)
        */

        // Initializations
        nationwideData = NationApi(id: UUID(), cases: 0, todayCases: 0, deaths: 0, todayDeaths: 0, active: 0)
        var casesFound = 0, todayCasesFound = 0, deathsFound = 0, todayDeathsFound = 0, activeFound = 0

        var jsonDataDictionary = Dictionary<String, Any>()

        if let jsonObject = jsonResponse as? [String: Any] {
           jsonDataDictionary = jsonObject
        } else {
           return
        }

        if let cases = jsonDataDictionary["cases"] as? Int {
            casesFound = cases
        }
        
        if let todayCases = jsonDataDictionary["todayCases"] as? Int {
            todayCasesFound = todayCases
        }
        
        if let deaths = jsonDataDictionary["deaths"] as? Int {
            deathsFound = deaths
        }
        
        if let todayDeaths = jsonDataDictionary["todayDeaths"] as? Int {
            todayDeathsFound = todayDeaths
        }
        
        if let active = jsonDataDictionary["active"] as? Int {
            activeFound = active
        }

        nationwideData = NationApi(id: UUID(), cases: casesFound, todayCases: todayCasesFound, deaths: deathsFound, todayDeaths: todayDeathsFound, active: activeFound)
    } catch {
        return
    }
}


