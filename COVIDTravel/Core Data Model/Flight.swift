//
//  Flight.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/29/21.
//

import Foundation
import CoreData

// ❎ CoreData Flight entity public class
public class Flight: NSManagedObject, Identifiable {
 
    @NSManaged public var airlineName: String?
    @NSManaged public var airlineWebsite: String?
    @NSManaged public var arrivalCode: String?
    @NSManaged public var arrivalDateTime: String?
    @NSManaged public var cost: NSNumber?
    @NSManaged public var departureCode: String?
    @NSManaged public var departureDateTime: String?
    @NSManaged public var notes: String?
    @NSManaged public var purpose: String?
    @NSManaged public var photo: Photo?
}

extension Flight {
    /*
     ❎ CoreData @FetchRequest in PlannedFlightsList.swift invokes this Flight class method
        to fetch all of the Flight entities from the database.
        The 'static' keyword designates the func as a class method invoked by using the
        class name as Flight.allFlightsFetchRequest() in any .swift file in your project.
     */
    static func allFlightsFetchRequest() -> NSFetchRequest<Flight> {
       
        let request: NSFetchRequest<Flight> = Flight.fetchRequest() as! NSFetchRequest<Flight>
        /*
         List the flights in ascending order with respect to departureDateTime;
         If departureDateTime is the same, then sort with respect to arrivalDateTime.
         */
        request.sortDescriptors = [
            // Primary sort key: departureDateTime
            NSSortDescriptor(key: "departureDateTime", ascending: true),
            // Secondary sort key: arrivalDateTime
            NSSortDescriptor(key: "arrivalDateTime", ascending: true)
        ]
       
        return request
    }
}
