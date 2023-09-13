//
//  StateApiData.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/17/21.
//

import SwiftUI

var stateData = StateApi(id: UUID(), country: "", state: "", overall: 0, cases: 0, deaths: 0, positiveTests: 0, negativeTests: 0, newCases: 0, newDeaths: 0, vaccinesDistributed: 0, vaccinationsInitiated: 0, vaccinationsCompleted: 0, vaccinationsAdministered: 0)
public func getStateDataFromApi(stateAbbr: String) {
    let stateDataApiUrl = "https://api.covidactnow.org/v2/state/\(stateAbbr).json?apiKey=\(COVIDActNowApiKey)"
    // The function is given in ApiData.swift
    let jsonDataFromApi = getJsonDataFromApi(apiUrl: stateDataApiUrl)

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
        var countryFound = "", stateFound = "", overallFound = 0, casesFound = 0, deathsFound = 0
        var positiveTestsFound = 0, negativeTestsFound = 0, newCasesFound = 0, newDeathsFound = 0
        var vaccinesDistributedFound = 0, vaccinationsInitiatedFound = 0, vaccinationsCompletedFound = 0, vaccinationsAdministeredFound = 0
            
        var jsonDataDictionary = Dictionary<String, Any>()

        if let jsonObject = jsonResponse as? [String: Any] {
           jsonDataDictionary = jsonObject
        } else {
           return
        }

        if let country = jsonDataDictionary["country"] as? String {
            countryFound = country
        }
        
        if let state = jsonDataDictionary["state"] as? String {
            stateFound = state
        }
        
        // Parsing through riskLevels Json object
        var riskLevelsJsonObject = [String: Any]()
        if let riskLevels = jsonDataDictionary["riskLevels"] as? [String: Any] {
            riskLevelsJsonObject = riskLevels
        }
        
        if let overall = riskLevelsJsonObject["overall"] as? Int {
            overallFound = overall
        }
        
        
        // Parsing through actuals Json object
        var actualsJsonObject = [String: Any]()
        if let actuals = jsonDataDictionary["actuals"] as? [String: Any] {
            actualsJsonObject = actuals
        }
        
        if let cases = actualsJsonObject["cases"] as? Int {
            casesFound = cases
        }
        
        if let deaths = actualsJsonObject["deaths"] as? Int {
            deathsFound = deaths
        }
        
        if let positiveTests = actualsJsonObject["positiveTests"] as? Int {
            positiveTestsFound = positiveTests
        }
        
        if let negativeTests = actualsJsonObject["negativeTests"] as? Int {
            negativeTestsFound = negativeTests
        }
        
        if let newCases = actualsJsonObject["newCases"] as? Int {
            newCasesFound = newCases
        }
        
        if let newDeaths = actualsJsonObject["newDeaths"] as? Int {
            newDeathsFound = newDeaths
        }
        
        if let vaccinesDistributed = actualsJsonObject["vaccinesDistributed"] as? Int {
            vaccinesDistributedFound = vaccinesDistributed
        }
        
        if let vaccinationsInitiated = actualsJsonObject["vaccinationsInitiated"] as? Int {
            vaccinationsInitiatedFound = vaccinationsInitiated
        }
        
        if let vaccinationsCompleted = actualsJsonObject["vaccinationsCompleted"] as? Int {
            vaccinationsCompletedFound = vaccinationsCompleted
        }
        
        if let vaccinationsAdministered = actualsJsonObject["vaccinationsAdministered"] as? Int {
            vaccinationsAdministeredFound = vaccinationsAdministered
        }
        
        stateData = StateApi(id: UUID(), country: countryFound, state: stateFound, overall: overallFound, cases: casesFound, deaths: deathsFound, positiveTests: positiveTestsFound, negativeTests: negativeTestsFound, newCases: newCasesFound, newDeaths: newDeathsFound, vaccinesDistributed: vaccinesDistributedFound, vaccinationsInitiated: vaccinationsInitiatedFound, vaccinationsCompleted: vaccinationsCompletedFound, vaccinationsAdministered: vaccinationsAdministeredFound)
    } catch {
        return
    }
}


