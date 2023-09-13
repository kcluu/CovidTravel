//
//  AirportData.swift
//  Covid19
//
//  Created by Yongjae Lim on 4/15/21.
//  Copyright © 2021 Yongjae Lim. All rights reserved.
//

import SwiftUI
import CoreData
 
// Array of Airport structs for use only in this file
fileprivate var airportStructList = [AirportStruct]()
 
/*
 ***********************************
 MARK: - Create  Database
 ***********************************
 */
public func createAirportsDatabase() {
 
    airportStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "AirportsData.json", fileLocation: "Main Bundle")
   
    populateDatabase()
}
 
/*
*********************************************
MARK: - Populate Database If Not Already Done
*********************************************
*/
func populateDatabase() {
   
    // ❎ Get object reference of CoreData managedObjectContext from the persistent container
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    //----------------------------
    // ❎ Define the Fetch Request
    //----------------------------
    let fetchRequest = NSFetchRequest<Airport>(entityName: "Airport")
    fetchRequest.sortDescriptors = [
        // Primary sort key: City Name
        NSSortDescriptor(key: "name", ascending: true),
        // Secondary sort key: Airport Name
        NSSortDescriptor(key: "iataCode", ascending: true)
    ]
   
    var listOfAllAirportEntitiesInDatabase = [Airport]()
   
    do {
        //-----------------------------
        // ❎ Execute the Fetch Request
        //-----------------------------
        listOfAllAirportEntitiesInDatabase = try managedObjectContext.fetch(fetchRequest)
    } catch {
        print("Populate Database Failed!")
        return
    }
   
    if listOfAllAirportEntitiesInDatabase.count > 0 {
        // Database has already been populated
        print("Database has already been populated!")
        return
    }
   
    print("Database will be populated!")
    
    for airport in airportStructList {
        /*
         ========================================================
         Create an instance of the Airport Entity and dress it up
         ========================================================
        */
       
        // ❎ Create an instance of the Airport entity in CoreData managedObjectContext
        let airportEntity = Airport(context: managedObjectContext)
       
        // ❎ Dress it up by specifying its attributes
        airportEntity.name = airport.name
        airportEntity.iataCode = airport.iata_code
        airportEntity.latitude = NSNumber(value: airport._geoloc.lat)
        airportEntity.longitude = NSNumber(value: airport._geoloc.lng)
        airportEntity.city = airport.city
        airportEntity.country = airport.country
 

        /*
         ==================================
         Save Changes to Core Data Database
         ==================================
        */
       
        // ❎ CoreData Save operation
        do {
            try managedObjectContext.save()
        } catch {
            return
        }
       
    }   // End of for loop
 
}
