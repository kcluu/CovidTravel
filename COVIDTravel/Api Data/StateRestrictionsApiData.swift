//
//  StateAPIData.swift
//  Covid19
//
//  Created by Yongjae Lim on 4/15/21.
//  Copyright © 2021 Yongjae Lim. All rights reserved.
//

import SwiftUI
import Foundation

var stateFound = StateStruct(id: UUID(), name: "", restrictions: "", photoName: "")
var stateStructList = [StateStruct]()

//let statesDictionary = ["Alabama": "AL", "Alaska": "AK", "Arizona": "AZ", "Arkansas": "AR", "California": "CA", "Colorado": "CO", "Connecticut": "CT", "Delaware": "DE", "Florida": "FL", "Georgia": "GA", "Hawaii": "HI", "Idaho": "ID", "Illinois": "IL", "Indiana": "IN", "Iowa": "IA", "Kansas": "KS", "Kentucky": "KY", "Louisiana": "LA", "Maine": "ME", "Maryland": "MD", "Massachusetts": "MA", "Michigan": "MI", "Minnesota": "MN", "Mississippi": "MS", "Missouri": "MO", "Montana": "MT", "Nebraska": "NE", "Nevada": "NV", "New Hampshire": "NH", "New Jersey": "NJ", "New Mexico": "NM", "New York": "NY", "North Carolina": "NC", "North Dakota": "ND", "Ohio": "OH", "Oklahoma": "OK", "Oregon": "OR", "Pennsylvania": "PA", "Rhode Island": "RI", "South Carolina": "SC", "South Dakota": "SD", "Tennessee": "TN", "Texas": "TX", "Utah": "UT", "Vermont": "VT", "Virginia": "VA", "Washington": "WA","Washington D.C.": "DC" ,"West Virginia": "WV", "Wisconsin": "WI", "Wyoming": "WY"]

public func obtainStateDataFromAPI() {
    // Initialization
    stateFound = StateStruct(id: UUID(), name: "", restrictions: "", photoName: "")
    
    /*
    **************************************
    *   Obtaining API Query URL Struct   *
    **************************************
    */
    
    let apiQueryUrlString = "https://parsehub.com/api/v2/projects/ttxBFdD4fGia/last_ready_run/data?api_key=tbiAK4DpCQC1"
    
    var apiQueryUrlStruct: URL?
    
    if let urlStruct = URL(string: apiQueryUrlString) {
        apiQueryUrlStruct = urlStruct
    } else {
        // stockQuoteFromApi will have the initial values set as above
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
        "host": "parsehub.com"
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
            // stockQuoteFromApi will have the initial values set as above
            semaphore.signal()
            return
        }
       
        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            // stockQuoteFromApi will have the initial values set as above
            semaphore.signal()
            return
        }
       
        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        guard let jsonDataFromApi = data else {
            // stockQuoteFromApi will have the initial values set as above
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
            var stateDictionary = Dictionary<String, Any>()
            
            if let jsonObject = jsonResponse as? [String: Any] {
                stateDictionary = jsonObject
            } else {
                // stockQuoteFromApi will have the initial values set as above
                semaphore.signal()
                return
            }

            //----------------
            // Initializations
            //----------------
            var name = "", restrictions = "", photoName = ""
            
            if let statesArray = stateDictionary["states"] as? [Any] {
                
                for stateObject in statesArray {
                    
                    if let stateInfoDictionary = stateObject as? [String:Any] {
                        
                        //------------------
                        // Obtain State Name
                        //------------------
                        if let stateName = stateInfoDictionary["name"] as? String {
                            name = stateName
                        }
                        
                        //--------------------------
                        // Obtain State Restrictions
                        //--------------------------
                        if let stateRestrictions = stateInfoDictionary["restrictions"] as? String {
                            restrictions = stateRestrictions
                        }
                        
                        //------------------
                        // Obtain State Flag
                        //------------------
                        if let flag = statesDictionary[name] {
                            photoName = flag.lowercased()
                        }
                        
                        if name != "Active travel restrictions" && name != "Timeline" {
                            stateFound = StateStruct(id: UUID(), name: name, restrictions: restrictions, photoName: photoName)
                            stateStructList.append(stateFound)
                        }
                    }
                } // End of For loop
            }
            
            
        } catch {
            // stockQuoteFromApi will have the initial values set as above
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
