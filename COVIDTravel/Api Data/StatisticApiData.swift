//
//  StatisticApiData.swift
//  CovidTravel
//
//  Created by James Kim on 4/14/21.
//

import Foundation
import SwiftUI



var statisticsFoundList = [Statistic]()
var sortedStatisticsFoundList = [Statistic]()
var searchableStatisticsList = [String]()




// Covid Act Now API
// https://api.covidactnow.org/v2/state/VA.json?apiKey=\(APIKey)

let APIKey = "72eedd63a75249a5937bc109f1cf163a"

fileprivate var previousStateName = ""

let statesDictionary = ["Alabama": "AL",
        "Alaska": "AK",
        "Arizona": "AZ",
        "Arkansas": "AR",
        "California": "CA",
        "Colorado": "CO",
        "Connecticut": "CT",
        "Delaware": "DE",
        "Florida": "FL",
        "Georgia": "GA",
        "Hawaii": "HI",
        "Idaho": "ID",
        "Illinois": "IL",
        "Indiana": "IN",
        "Iowa": "IA",
        "Kansas": "KS",
        "Kentucky": "KY",
        "Louisiana": "LA",
        "Maine": "ME",
        "Maryland": "MD",
        "Massachusetts": "MA",
        "Michigan": "MI",
        "Minnesota": "MN",
        "Mississippi": "MS",
        "Missouri": "MO",
        "Montana": "MT",
        "Nebraska": "NE",
        "Nevada": "NV",
        "New Hampshire": "NH",
        "New Jersey": "NJ",
        "New Mexico": "NM",
        "New York": "NY",
        "North Carolina": "NC",
        "North Dakota": "ND",
        "Ohio": "OH",
        "Oklahoma": "OK",
        "Oregon": "OR",
        "Pennsylvania": "PA",
        "Rhode Island": "RI",
        "South Carolina": "SC",
        "South Dakota": "SD",
        "Tennessee": "TN",
        "Texas": "TX",
        "Utah": "UT",
        "Vermont": "VT",
        "Virginia": "VA",
        "Washington": "WA",
        "West Virginia": "WV",
        "Wisconsin": "WI",
        "Wyoming": "WY"]

public func populateStatisticsFoundList() {
    for (key, value) in statesDictionary {
        obtainStatisticDataFromApi(stateName: value, fullStateName: key)
    }
    sortedStatisticsFoundList = statisticsFoundList.sorted(by: { $0.state < $1.state })
    
    for stat in sortedStatisticsFoundList {
        let selectedStatisticAttributesForSearch = "\(stat.id)|\(stat.fullState)|\(stat.state)"
       
        searchableStatisticsList.append(selectedStatisticAttributesForSearch)
    }

}

/*
====================================
MARK: - Obtain Statistic Data from API
====================================
*/
public func obtainStatisticDataFromApi(stateName: String, fullStateName: String) {
   
    // Avoid executing this function if already done for the same category and query
    if stateName == previousStateName {
        return
    } else {
        previousStateName = stateName
    }
   
    // Initialization
    // Declare statisticFound as a global mutable variable accessible in all Swift files
    let uuid = UUID()
    var statisticFound = Statistic(id: uuid, country: "", state: "", fullState: "", population: 0, riskLevel: 0, cases: 0, deaths: 0, positiveTests: 0, negativeTests: 0, newCases: 0, newDeaths: 0, vaccinesDistributed: 0, vaccinationsInitiated: 0, vaccinationsCompleted: 0, vaccinesAdministered: 0)
    
   
    /*
     *********************************************
     *   Obtaining API Search Query URL Struct   *
     *********************************************
     */

    let apiUrl = "https://api.covidactnow.org/v2/state/\(stateName).json?apiKey=\(APIKey)"
   
    /*
     searchQuery may include unrecognizable foreign characters inputted by the user,
     e.g., Côte d'Ivoire, that can prevent the creation of a URL struct from the
     given apiUrl string. Therefore, we must test it as an Optional.
    */
    var apiQueryUrlStruct: URL?
   
    if let urlStruct = URL(string: apiUrl) {
        apiQueryUrlStruct = urlStruct
    } else {
        return
    }
 
    /*
    *******************************
    *   HTTP GET Request Set Up   *
    *******************************
    */
    
   
    let headers = [
        "accept": "application/json",
        "cache-control": "no-cache",
        "host": "api.covidactnow.org"
    ]
 
    
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
 
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
 
    /*
    *********************************************************************
    *  Setting Up a URL Session to Fetch the JSON File from the API     *
    *  in an Asynchronous Manner and Processing the Received JSON File  *
    *********************************************************************
    */
   
    /*
     Create a semaphore to control getting and processing API data.
     signal() -> Int    Signals (increments) a semaphore.
     wait()             Waits for, or decrements, a semaphore.
     */
    let semaphore = DispatchSemaphore(value: 0)
 
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
       
        /*
        URLSession is established and the JSON file from the API is set to be fetched
        in an asynchronous manner. After the file is fetched, data, response, error
        are returned as the input parameter values of this Completion Handler Closure.
        */
 
        // Process input parameter 'error'
        guard error == nil else {
            semaphore.signal()
            return
        }
       
        /*
         ---------------------------------------------------------
         🔴 Any 'return' used within the completionHandler Closure
            exits the Closure; not the public function it is in.
         ---------------------------------------------------------
         */
 
        
        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            semaphore.signal()
            return
        }
 
        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        guard let jsonDataFromApi = data else {
            semaphore.signal()
            return
        }
 
        //------------------------------------------------
        // JSON data is obtained from the API. Process it.
        //------------------------------------------------
        do {
            
            /*
             Foundation framework’s JSONSerialization class is used to convert JSON data
             into Swift data types such as Dictionary, Array, String, Number, or Bool.
             */
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                               options: JSONSerialization.ReadingOptions.mutableContainers)
 
            /*
             JSON object with Attribute-Value pairs corresponds to Swift Dictionary type with
             Key-Value pairs. Therefore, we use a Dictionary to represent a JSON object
             where Dictionary Key type is String and Value type is Any (instance of any type)
             */
            var statisticDataDictionary = Dictionary<String, Any>()   // Or [String: Any]()

                /*
                 Returns a JSON Object of drinks array {jsonObject}
                 */
            if let jsonObject = jsonResponse as? [String: Any] {
                    statisticDataDictionary = jsonObject
                } else {
                    semaphore.signal()
                    return
                }
            
           
            //----------------
            // Initializations
            //----------------
            var country = "", state = "", fullState = "", population = 0, riskLevel = 0, cases = 0, deaths = 0, positiveTests = 0, negativeTests = 0, newCases = 0, newDeaths = 0, vaccinesDistributed = 0, vaccinationsInitiated = 0, vaccinationsCompleted = 0, vaccinesAdministered = 0
           
            //--------------------
            // Obtain statistic json array
            //--------------------

            if let countryName = statisticDataDictionary["country"] as? String {
                country = countryName
            }
            
            if let stateName = statisticDataDictionary["state"] as? String {
                state = stateName
                
            }
            
            fullState = fullStateName
            
            if let pop = statisticDataDictionary["population"] as? Int {
                population = pop
            }
            
            var riskLevelJsonObj = [String: Any]()
            if let riskObj = statisticDataDictionary["riskLevels"] as? [String: Any] {
                riskLevelJsonObj = riskObj
            }
            
            if let risk = riskLevelJsonObj["overall"] as? Int {
                riskLevel = risk
            }
            
            var actualsJsonObj = [String: Any]()
            if let actualsObj = statisticDataDictionary["actuals"] as? [String: Any] {
                actualsJsonObj = actualsObj
            }
            
            if let totalCases = actualsJsonObj["cases"] as? Int {
                cases = totalCases
            }
            
            if let totalDeaths = actualsJsonObj["deaths"] as? Int {
                deaths = totalDeaths
            }
            
            if let totalPositives = actualsJsonObj["positiveTests"] as? Int {
                positiveTests = totalPositives
            }
            
            if let totalNegatives = actualsJsonObj["negativeTests"] as? Int {
                negativeTests = totalNegatives
            }
            
            if let totalNewCases = actualsJsonObj["newCases"] as? Int {
                newCases = totalNewCases
            }
            
            if let totalNewDeaths = actualsJsonObj["newDeaths"] as? Int {
                newDeaths = totalNewDeaths
            }
            
            if let totalDistributed = actualsJsonObj["vaccinesDistributed"] as? Int {
                vaccinesDistributed = totalDistributed
            }
            
            if let totalInitiated = actualsJsonObj["vaccinationsInitiated"] as? Int {
                vaccinationsInitiated = totalInitiated
            }
            
            if let totalCompleted = actualsJsonObj["vaccinationsCompleted"] as? Int {
                vaccinationsCompleted = totalCompleted
            }
            
            if let totalAdministered = actualsJsonObj["vaccinesAdministered"] as? Int {
                vaccinesAdministered = totalAdministered
            }
            
            //----------------------------------------------------------
            // Construct a New Statistic Struct and Set it to statisticFound
            //----------------------------------------------------------
            
           
            statisticFound = Statistic(id: uuid, country: country, state: state, fullState: fullState, population: population, riskLevel: riskLevel, cases: cases, deaths: deaths, positiveTests: positiveTests, negativeTests: negativeTests, newCases: newCases, newDeaths: newDeaths, vaccinesDistributed: vaccinesDistributed, vaccinationsInitiated: vaccinationsInitiated, vaccinationsCompleted: vaccinationsCompleted, vaccinesAdministered: vaccinesAdministered)
            
            statisticsFoundList.append(statisticFound)
            
        } catch {
            semaphore.signal()

            return
        }
 
        semaphore.signal()
    }).resume()
 
    /*
     The URLSession task above is set up. It begins in a suspended state.
     The resume() method starts processing the task in an execution thread.
 
     The semaphore.wait blocks the execution thread and starts waiting.
     Upon completion of the task, the Completion Handler code is executed.
     The waiting ends when .signal() fires or timeout period of 10 seconds expires.
    */
 
    _ = semaphore.wait(timeout: .now() + 10)
 
}
