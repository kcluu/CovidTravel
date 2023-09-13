//
//  PlannedFlightItem.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/29/21.
//

import SwiftUI

struct PlannedFlightItem: View {
    // ❎ Input parameter: CoreData Flight Entity instance reference
    let flight: Flight
   
    // ❎ CoreData FetchRequest returning all Flight entities in the database
    @FetchRequest(fetchRequest: Flight.allFlightsFetchRequest()) var allFlights: FetchedResults<Flight>
   
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Flight entities with all the changes.
    @EnvironmentObject var userData: UserData
   
    var body: some View {
        HStack {
            // This public function is given in UtilityFunctions.swift
            getImageFromUrl(url: "https://logo.clearbit.com/\(manipulatedAirlineWebsite)", defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70.0)
           
            VStack(alignment: .leading) {
                Text(flight.airlineName ?? "")
                HStack {
                    Text(flight.departureCode ?? "")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text(flight.arrivalCode ?? "")
                        .fontWeight(.semibold)
                }
                HStack {
                    Image(systemName: "clock")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    VStack (alignment: .leading) {
                        Text("Departure Date:")
                        Text(fullDepartureDate)
                            .fontWeight(.semibold)
                    }
                }
            }
            .font(.system(size: 14))
        }
    }
    // Manipulates the string of the website data in order to use with a logo getter website.
    var manipulatedAirlineWebsite: String {
        return String(flight.airlineWebsite!.dropFirst(12))
    }
    
    // Converts the departure date to a more user friendly, readable format.
    var fullDepartureDate: String {
        let stringDate = flight.departureDateTime!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyy-MM-dd 'at' HH:mm:ss"
        let flightDate = dateFormatter.date(from: stringDate)
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.locale = Locale(identifier: "en_US")
        newDateFormatter.dateFormat = "E, MMM d, yyyy 'at' h:mm a"
        return newDateFormatter.string(from: flightDate!)
    }
}
