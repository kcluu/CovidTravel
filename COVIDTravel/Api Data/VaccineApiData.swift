//
//  VaccineData.swift
//  CovidTravel
//
//  Created by James Kim on 4/19/21.
//  Copyright © 2021 James Kim. All rights reserved.
//

import Foundation
import SwiftUI

var vaccineFound = Vaccine(id: "", latitude: 0.0, longitude: 0.0, url: "", city: "", state: "", address: "", hasVaccine: false, providerName: "", appointmentsAvailable: false, vaccineType: "")

var vaccinesFoundList = [Vaccine]()

// Vaccine Spotter API
// https://www.vaccinespotter.org/api/v0/states/\(State).json

fileprivate var previousStateName = ""
fileprivate var previousCityName = ""


/*
====================================
MARK: - Obtain Vaccine Data from API
====================================
*/
public func obtainVaccineDataFromApi(stateName: String, cityName: String) {
   
    // Avoid executing this function if already done for the same category and query
    if stateName == previousStateName && cityName == previousCityName {
        return
    } else {
        previousStateName = stateName
        previousCityName = cityName
    }
    
    vaccinesFoundList.removeAll()
   
    // Initialization
    // Declare vaccineFound as a global mutable variable accessible in all Swift files
    vaccineFound = Vaccine(id: "", latitude: 0.0, longitude: 0.0, url: "", city: "", state: "", address: "", hasVaccine: false, providerName: "", appointmentsAvailable: false, vaccineType: "")
    
   
    /*
     *********************************************
     *   Obtaining API Search Query URL Struct   *
     *********************************************
     */

    let apiUrl = "https://www.vaccinespotter.org/api/v0/states/\(stateName).json"
   
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
        //"host": "vaccinespotter.org"
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
            // weatherFound will have the initial values set as above
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
            var vaccineDataDictionary = Dictionary<String, Any>()   // Or [String: Any]()

                /*
                 Returns a JSON Object of drinks array {jsonObject}
                 */
            if let jsonObject = jsonResponse as? [String: Any] {
                    vaccineDataDictionary = jsonObject
                } else {
                    // vaccineFound will have the initial values set as above
                    semaphore.signal()
                    return
                }
            
            if let stateResults = vaccineDataDictionary["features"] as? [Any] {
                for stateResult in stateResults {
                    
                    var latitude = 0.0, longitude = 0.0, url = "", city = "", state = "", address = "", hasVaccine = false, providerName = "", appointmentsAvailable = false, vaccineType = ""
                    
                    var vaccineJsonObject = [String: Any]()
                    
                    if let vaccineObject = stateResult as? [String: Any] {
                        vaccineJsonObject = vaccineObject
                    } else {
                        return
                    }
                    
                    
                    if let properties = vaccineJsonObject["properties"] as? [String: Any] {
                        
                        // City
                        if let nameOfCity = properties["city"] as? String {
                            if nameOfCity == cityName {
                                city = nameOfCity
                            }
                            else {
                                continue
                            }
                        }
                        else {
                            continue
                        }
                        
                        // State
                        if let nameOfState = properties["state"] as? String {
                            state = nameOfState
                        }
                        
                        // URL
                        if let webUrl = properties["url"] as? String {
                            url = webUrl
                        }
                        else {
                            url = "Unavailable"
                        }
                        
                        // URL
                        if let addr = properties["address"] as? String {
                            address = addr
                        }
                        else {
                            address = "Unavailable"
                        }
                        
                        // Availability of vaccine
                        if let vaccineAvail = properties["carries_vaccine"] as? Bool {
                            hasVaccine = vaccineAvail
                        }
                        
                        // Provider name
                        if let provider = properties["provider_brand_name"] as? String {
                            providerName = provider
                        }
                        else {
                            providerName = "Unavailable"
                        }

                        // Availability of appointments
                        if let appointmentsAvail = properties["appointments_available"] as? Bool {
                            appointmentsAvailable = appointmentsAvail
                        }
                        
                        if let types = properties["appointment_vaccine_types"] as? [String: Bool] {
                            if !types.isEmpty {
                                vaccineType = Array(types)[0].key.capitalized
                            }
                            else {
                                vaccineType = "Unknown. Please contact the provider for more information."
                            }

                        }
                        else {
                            vaccineType = "Unknown. Please contact the provider for more information."
                        }
                        
                    }
                    else {
                        continue
                    }
                    
                    if let geometry = vaccineJsonObject["geometry"] as? [String: Any] {
                        
                        // Coordinates
                        if let coordinates = geometry["coordinates"] as? [Double] {
                            latitude = coordinates[0]
                            longitude = coordinates[1]
                        }
                    }
                                        
                    vaccineFound = Vaccine(id: "", latitude: latitude, longitude: longitude, url: url, city: city, state: state, address: address, hasVaccine: hasVaccine, providerName: providerName, appointmentsAvailable: appointmentsAvailable, vaccineType: vaccineType)
                    
                    vaccinesFoundList.append(vaccineFound)
                }
            }

            
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
