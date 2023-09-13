//
//  NationwideTimeseriesApiData.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/16/21.
//

import SwiftUI

var nationwideTimeseries = NationwideTimeseries(oneDays: "", twoDays: "", threeDays: "", fourDays: "", fiveDays: "", sixDays: "", sevenDays: "", oneCases: 0, twoCases: 0, threeCases: 0, fourCases: 0, fiveCases: 0, sixCases: 0, sevenCases: 0, oneDeaths: 0, twoDeaths: 0, threeDeaths: 0, fourDeaths: 0, fiveDeaths: 0, sixDeaths: 0, sevenDeaths: 0, oneRecovered: 0, twoRecovered: 0, threeRecovered: 0, fourRecovered: 0, fiveRecovered: 0, sixRecovered: 0, sevenRecovered: 0)
public func getNationwideTimeseriesDataFromApi() {
    let nationwideTimeseriesDataApiUrl = "https://corona.lmao.ninja/v2/historical/USA?lastdays=7"
    // The function is given in ApiData.swift
    let jsonDataFromApi = getJsonDataFromApi(apiUrl: nationwideTimeseriesDataApiUrl)

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
        nationwideTimeseries = NationwideTimeseries(oneDays: "", twoDays: "", threeDays: "", fourDays: "", fiveDays: "", sixDays: "", sevenDays: "", oneCases: 0, twoCases: 0, threeCases: 0, fourCases: 0, fiveCases: 0, sixCases: 0, sevenCases: 0, oneDeaths: 0, twoDeaths: 0, threeDeaths: 0, fourDeaths: 0, fiveDeaths: 0, sixDeaths: 0, sevenDeaths: 0, oneRecovered: 0, twoRecovered: 0, threeRecovered: 0, fourRecovered: 0, fiveRecovered: 0, sixRecovered: 0, sevenRecovered: 0)
        var oneCasesFound = 0, twoCasesFound = 0, threeCasesFound = 0, fourCasesFound = 0, fiveCasesFound = 0, sixCasesFound = 0, sevenCasesFound = 0
        var oneDeathsFound = 0, twoDeathsFound = 0, threeDeathsFound = 0, fourDeathsFound = 0, fiveDeathsFound = 0, sixDeathsFound = 0, sevenDeathsFound = 0
        var oneRecoveredFound = 0, twoRecoveredFound = 0, threeRecoveredFound = 0, fourRecoveredFound = 0, fiveRecoveredFound = 0, sixRecoveredFound = 0, sevenRecoveredFound = 0

        var jsonDataDictionary = Dictionary<String, Any>()

        if let jsonObject = jsonResponse as? [String: Any] {
           jsonDataDictionary = jsonObject
        } else {
           return
        }

        var timelineJsonObject = [String:Any]()
        if let timeline = jsonDataDictionary["timeline"] as? [String: Any] {
            timelineJsonObject = timeline
        }
        
        // Date set up
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        // Set up for one day ago
        var dateComponent = DateComponents()
        dateComponent.day = -1
        let oneDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        let oneDayAgo = dateFormatter.string(from: oneDate!)
        
        // Set up for two days ago
        var dateComponent2 = DateComponents()
        dateComponent2.day = -2
        let twoDate = Calendar.current.date(byAdding: dateComponent2, to: currentDate)
        let twoDaysAgo = dateFormatter.string(from: twoDate!)
        
        // Set up for three days ago
        var dateComponent3 = DateComponents()
        dateComponent3.day = -3
        let threeDate = Calendar.current.date(byAdding: dateComponent3, to: currentDate)
        let threeDaysAgo = dateFormatter.string(from: threeDate!)
        
        // Set up for four days ago
        var dateComponent4 = DateComponents()
        dateComponent4.day = -4
        let fourDate = Calendar.current.date(byAdding: dateComponent4, to: currentDate)
        let fourDaysAgo = dateFormatter.string(from: fourDate!)
        
        // Set up for five days ago
        var dateComponent5 = DateComponents()
        dateComponent5.day = -5
        let fiveDate = Calendar.current.date(byAdding: dateComponent5, to: currentDate)
        let fiveDaysAgo = dateFormatter.string(from: fiveDate!)
        
        // Set up for six days ago
        var dateComponent6 = DateComponents()
        dateComponent6.day = -6
        let sixDate = Calendar.current.date(byAdding: dateComponent6, to: currentDate)
        let sixDaysAgo = dateFormatter.string(from: sixDate!)
        
        // Set up for seven days ago
        var dateComponent7 = DateComponents()
        dateComponent7.day = -7
        let sevenDate = Calendar.current.date(byAdding: dateComponent7, to: currentDate)
        let sevenDaysAgo = dateFormatter.string(from: sevenDate!)
        
        // Parse through 7 days of cases
        var casesJsonObject = [String: Any]()
        if let cases = timelineJsonObject["cases"] as? [String: Any] {
            casesJsonObject = cases
        }
        
        if let oneCases = casesJsonObject["\(oneDayAgo)"] as? Int {
            oneCasesFound = oneCases
        }
        
        if let twoCases = casesJsonObject["\(twoDaysAgo)"] as? Int {
            twoCasesFound = twoCases
        }
        
        if let threeCases = casesJsonObject["\(threeDaysAgo)"] as? Int {
            threeCasesFound = threeCases
        }
        
        if let fourCases = casesJsonObject["\(fourDaysAgo)"] as? Int {
            fourCasesFound = fourCases
        }
        
        if let fiveCases = casesJsonObject["\(fiveDaysAgo)"] as? Int {
            fiveCasesFound = fiveCases
        }
        
        if let sixCases = casesJsonObject["\(sixDaysAgo)"] as? Int {
            sixCasesFound = sixCases
        }
        
        if let sevenCases = casesJsonObject["\(sevenDaysAgo)"] as? Int {
            sevenCasesFound = sevenCases
        }
        
        // Parse through 7 days of deaths
        var deathsJsonObject = [String: Any]()
        if let deaths = timelineJsonObject["deaths"] as? [String: Any] {
            deathsJsonObject = deaths
        }
        
        if let oneDeaths = deathsJsonObject["\(oneDayAgo)"] as? Int {
            oneDeathsFound = oneDeaths
        }
        
        if let twoDeaths = deathsJsonObject["\(twoDaysAgo)"] as? Int {
            twoDeathsFound = twoDeaths
        }
        
        if let threeDeaths = deathsJsonObject["\(threeDaysAgo)"] as? Int {
            threeDeathsFound = threeDeaths
        }
        
        if let fourDeaths = deathsJsonObject["\(fourDaysAgo)"] as? Int {
            fourDeathsFound = fourDeaths
        }
        
        if let fiveDeaths = deathsJsonObject["\(fiveDaysAgo)"] as? Int {
            fiveDeathsFound = fiveDeaths
        }
        
        if let sixDeaths = deathsJsonObject["\(sixDaysAgo)"] as? Int {
            sixDeathsFound = sixDeaths
        }
        
        if let sevenDeaths = deathsJsonObject["\(sevenDaysAgo)"] as? Int {
            sevenDeathsFound = sevenDeaths
        }

        // Parse through 7 days of recovered
        var recoveredJsonObject = [String: Any]()
        if let recovered = timelineJsonObject["recovered"] as? [String: Any] {
            recoveredJsonObject = recovered
        }
        
        if let oneRecovered = recoveredJsonObject["\(oneDayAgo)"] as? Int {
            oneRecoveredFound = oneRecovered
        }
        
        if let twoRecovered = recoveredJsonObject["\(twoDaysAgo)"] as? Int {
            twoRecoveredFound = twoRecovered
        }
        
        if let threeRecovered = recoveredJsonObject["\(threeDaysAgo)"] as? Int {
            threeRecoveredFound = threeRecovered
        }
        
        if let fourRecovered = recoveredJsonObject["\(fourDaysAgo)"] as? Int {
            fourRecoveredFound = fourRecovered
        }
        
        if let fiveRecovered = recoveredJsonObject["\(fiveDaysAgo)"] as? Int {
            fiveRecoveredFound = fiveRecovered
        }
        
        if let sixRecovered = recoveredJsonObject["\(sixDaysAgo)"] as? Int {
            sixRecoveredFound = sixRecovered
        }
        
        if let sevenRecovered = recoveredJsonObject["\(sevenDaysAgo)"] as? Int {
            sevenRecoveredFound = sevenRecovered
        }
        
        nationwideTimeseries = NationwideTimeseries(oneDays: oneDayAgo, twoDays: twoDaysAgo, threeDays: threeDaysAgo, fourDays: fourDaysAgo, fiveDays: fiveDaysAgo, sixDays: sixDaysAgo, sevenDays: sevenDaysAgo, oneCases: oneCasesFound, twoCases: twoCasesFound, threeCases: threeCasesFound, fourCases: fourCasesFound, fiveCases: fiveCasesFound, sixCases: sixCasesFound, sevenCases: sevenCasesFound, oneDeaths: oneDeathsFound, twoDeaths: twoDeathsFound, threeDeaths: threeDeathsFound, fourDeaths: fourDeathsFound, fiveDeaths: fiveDeathsFound, sixDeaths: sixDeathsFound, sevenDeaths: sevenDeathsFound, oneRecovered: oneRecoveredFound, twoRecovered: twoRecoveredFound, threeRecovered: threeRecoveredFound, fourRecovered: fourRecoveredFound, fiveRecovered: fiveRecoveredFound, sixRecovered: sixRecoveredFound, sevenRecovered: sevenRecoveredFound)
    } catch {
        return
    }
}
