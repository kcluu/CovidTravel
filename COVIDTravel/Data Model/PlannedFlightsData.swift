//
//  PlannedFlightsData.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/29/21.
//

import SwiftUI
import CoreData

// Array of Flight structs for use only in this file
fileprivate var plannedFlightsStructList = [PlannedFlight]()

/*
 ***********************************
 MARK: - Create Planned Flights Database
 ***********************************
 */
public func createPlannedFlightsDatabase() {
 
    plannedFlightsStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "PlannedFlightsData.json", fileLocation: "Main Bundle")
   
    populatePlannedFlightsDatabase()
}

/*
*********************************************
MARK: - Populate Database If Not Already Done
*********************************************
*/
func populatePlannedFlightsDatabase() {
   
    // ❎ Get object reference of CoreData managedObjectContext from the persistent container
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    //----------------------------
    // ❎ Define the Fetch Request
    //----------------------------
    let fetchRequest = NSFetchRequest<Flight>(entityName: "Flight")
    fetchRequest.sortDescriptors = [
        // Primary sort key: lastName
        NSSortDescriptor(key: "departureDateTime", ascending: true),
        // Secondary sort key: firstName
        NSSortDescriptor(key: "arrivalDateTime", ascending: true)
    ]
   
    var listOfAllPlannedFlightEntitiesInDatabase = [Flight]()
   
    do {
        //-----------------------------
        // ❎ Execute the Fetch Request
        //-----------------------------
        listOfAllPlannedFlightEntitiesInDatabase = try managedObjectContext.fetch(fetchRequest)
    } catch {
        print("Populate Database Failed!")
        return
    }
   
    if listOfAllPlannedFlightEntitiesInDatabase.count > 0 {
        // Database has already been populated
        print("Database has already been populated!")
        return
    }
   
    print("Database will be populated!")
   
    for flight in plannedFlightsStructList {
        /*
         =====================================================
         Create an instance of the Flight Entity and dress it up
         =====================================================
        */
       
        // ❎ Create an instance of the Flight entity in CoreData managedObjectContext
        let flightEntity = Flight(context: managedObjectContext)
       
        // ❎ Dress it up by specifying its attributes
        flightEntity.airlineName = flight.airlineName
        flightEntity.departureCode = flight.departureCode
        flightEntity.departureDateTime = flight.departureDateTime
        flightEntity.cost = NSNumber(value: flight.cost)
        flightEntity.arrivalCode = flight.arrivalCode
        flightEntity.arrivalDateTime = flight.arrivalDateTime
        flightEntity.notes = flight.notes
        flightEntity.purpose = flight.purpose
        flightEntity.airlineWebsite = flight.airlineWebsite
 
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
         */
       
        // ❎ Create an instance of the Photo Entity in CoreData managedObjectContext
        let photoEntity = Photo(context: managedObjectContext)
       
        // Obtain the flight photo image from Assets.xcassets as UIImage
        let photoUIImage = UIImage(named: flight.photoFullFilename)
       
        // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
        let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
       
        // Assign photoData to Core Data entity attribute of type Data (Binary Data)
        photoEntity.flightPhoto = photoData!
       
        /*
         ==============================
         Establish Entity Relationships
         ==============================
        */
       
        // ❎ Establish Relationship between entities Flight and Photo
        flightEntity.photo = photoEntity
        photoEntity.flight = flightEntity
       
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
