//
//  StateTimeseriesApiData.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/14/21.
//

import SwiftUI

var stateTimeseriesList = [StateTimeseries]()
var stateTimeseries = StateTimeseries(id: UUID(), country: "", state: "", cases: 0, deaths: 0, positiveTests: 0, negativeTests: 0, newCases: 0, newDeaths: 0, date: "")
var COVIDActNowApiKey = "72eedd63a75249a5937bc109f1cf163a"
public func getStateTimeseriesFromApi(stateAbbr: String) {
    stateTimeseriesList.removeAll()
    let stateTimeseriesApiUrl = "https://api.covidactnow.org/v2/state/\(stateAbbr).timeseries.json?apiKey=\(COVIDActNowApiKey)"
    // The function is given in ApiData.swift
    let jsonDataFromApi = getJsonDataFromApi(apiUrl: stateTimeseriesApiUrl)

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
        var countryFound = "", stateFound = "", casesFound = 0, deathsFound = 0
        var positiveTestsFound = 0, negativeTestsFound = 0, newCasesFound = 0, newDeathsFound = 0
        var dateFound = ""

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
        
        var actualsTimeseriesArray = [Any]()
        if let jArray = jsonDataDictionary["actualsTimeseries"] as? [Any] {
            actualsTimeseriesArray = jArray
        }

        // Obtain Results JSON Object
        var timeSeriesJsonObject = [String: Any]()
        for eachDate in actualsTimeseriesArray {
            if let jObject = eachDate as? [String: Any] {
                timeSeriesJsonObject = jObject
            } else {
                return
            }

            // Obtain Number of Cases
            if let cases = timeSeriesJsonObject["cases"] as? Int {
                casesFound = cases
            }

            // Obtain Number of Deaths
            if let deaths = timeSeriesJsonObject["deaths"] as? Int {
                deathsFound = deaths
            }

            // Obtain Number of Positive Tests
            if let positiveTests = timeSeriesJsonObject["positiveTests"] as? Int {
                positiveTestsFound = positiveTests
            }

            // Obtain Number of Negative Tests
            if let negativeTests = timeSeriesJsonObject["negativeTests"] as? Int {
                negativeTestsFound = negativeTests
            }
            
            // Obtain Number of New Cases
            if let newCases = timeSeriesJsonObject["newCases"] as? Int {
                newCasesFound = newCases
            }

            // Obtain Number of New Deaths
            if let newDeaths = timeSeriesJsonObject["newDeaths"] as? Int {
                newDeathsFound = newDeaths
            }

            // Obtain Number of Negative Tests
            if let date = timeSeriesJsonObject["date"] as? String {
                dateFound = date
            }

            stateTimeseries = StateTimeseries(id: UUID(), country: countryFound, state: stateFound, cases: casesFound, deaths: deathsFound, positiveTests: positiveTestsFound, negativeTests: negativeTestsFound, newCases: newCasesFound, newDeaths: newDeathsFound, date: dateFound)
            stateTimeseriesList.append(stateTimeseries)
        }
    } catch {
        return
    }
}


