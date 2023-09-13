//
//  Airport.swift
//  Covid19
//
//  Created by Yongjae Lim on 4/15/21.
//  Copyright © 2021 Yongjae Lim. All rights reserved.
//

import Foundation
import CoreData

public class Airport: NSManagedObject, Identifiable {
    @NSManaged public var name: String?
    @NSManaged public var iataCode: String?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var country: String?
    @NSManaged public var city: String?
    //@NSManaged public var location: Location?
    
}

extension Airport {
    /*
     ❎ CoreData @FetchRequest in AirportsList.swift invokes this Airport class method
        to fetch all of the Airport entities from the database.
        The 'static' keyword designates the func as a class method invoked by using the
        class name as Airport.allAirportsFetchRequest() in any .swift file in your project.
     */
    static func allAirportsFetchRequest() -> NSFetchRequest<Airport> {
       
        let request: NSFetchRequest<Airport> = Airport.fetchRequest() as! NSFetchRequest<Airport>
        /*
         List the airports in alphabetical order with respect to airportName;
         If airportName is the same, then sort with respect to iataCode.
         */
        request.sortDescriptors = [
            // Primary sort key: Airport Name
            NSSortDescriptor(key: "name", ascending: true),
            // Secondary sort key: IATA Code
            NSSortDescriptor(key: "iataCode", ascending: true)
        ]
       
        return request
    }
   
    /*
     ❎ CoreData @FetchRequest in SearchDatabase.swift invokes this Airport class method
        to fetch filtered Airport entities from the database for the given search query.
        The 'static' keyword designates the func as a class method invoked by using the
        class name as Airport.filteredAirportsFetchRequest() in any .swift file in your project.
     */
    static func filteredAirportsFetchRequest(searchCategory: String, searchQuery: String) -> NSFetchRequest<Airport> {
       
        let fetchRequest = NSFetchRequest<Airport>(entityName: "Airport")
       
        /*
         List the found airports in alphabetical order with respect to airportName;
         If airportName is the same, then sort with respect to iataCode.
         */
        fetchRequest.sortDescriptors = [
            // Primary sort key: City Name
            NSSortDescriptor(key: "name", ascending: true),
            // Secondary sort key: IATA Code
            NSSortDescriptor(key: "city", ascending: true)
        ]
        
        switch searchCategory {
        case "Airport Name":
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchQuery)
            print(searchQuery)
            
        case "City":
            fetchRequest.predicate = NSPredicate(format: "city CONTAINS[c] %@", searchQuery)
            print(searchQuery)
        default:
            print("Search category is out of range")
        }
        return fetchRequest
    }
}
