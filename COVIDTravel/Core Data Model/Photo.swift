//
//  Photo.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/29/21.
//

import Foundation
import CoreData
 
// ❎ CoreData Photo entity public class
public class Photo: NSManagedObject, Identifiable {
 
    @NSManaged public var flightPhoto: Data?
    @NSManaged public var flight: Flight?
}
