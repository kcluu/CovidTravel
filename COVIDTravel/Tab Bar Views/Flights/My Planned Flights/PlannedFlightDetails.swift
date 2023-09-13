//
//  PlannedFlightDetails.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/29/21.
//

import SwiftUI

struct PlannedFlightDetails: View {
    // ❎ Input parameter: CoreData Flight Entity instance reference
    let flight: Flight
    // ❎ CoreData FetchRequest returning all Flight entities in the database
    @FetchRequest(fetchRequest: Flight.allFlightsFetchRequest()) var allFlights: FetchedResults<Flight>
   
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Flight entities with all the changes.
    @EnvironmentObject var userData: UserData
    var body: some View {
        Form {
            if (isUpcomingFlight(flight: flight)) {
                Section(header: Text("Change This Flight's Attributes")) {
                    NavigationLink(destination: ChangePlannedFlight(flight: flight)) {
                        HStack {
                            Image(systemName: "pencil.circle")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                                .foregroundColor(.blue)
                            Text("Change Flight")
                        }
                    }
                }
            }
            Section(header: Text("Airline Name")) {
                Text(flight.airlineName ?? "")
            }
            Section(header: Text("Departure Details")) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Airport Departure Code: ")
                            .fontWeight(.semibold)
                        Text(flight.departureCode ?? "")
                    }
                    HStack {
                        Text("Departure Date: ")
                            .fontWeight(.semibold)
                        Text(fullDepartureDate)
                    }
                }
            }
            Section(header: Text("Arrival Details")) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Airport Arrival Code: ")
                            .fontWeight(.semibold)
                        Text(flight.arrivalCode ?? "")
                    }
                    HStack {
                        Text("Arrival Date: ")
                            .fontWeight(.semibold)
                        Text(fullArrivalDate)
                    }
                }
            }
            Section(header: Text("Flight Cost")) {
                flightCost
            }
            Section(header: Text("Flight Purpose")) {
                Text(flight.purpose ?? "")
            }
            Section(header: Text("Notes")) {
                Text(flight.notes ?? "")
            }
            Section(header: Text("Boarding Pass")) {
                // This public function is given in UtilityFunctions.swift
                getImageFromBinaryData(binaryData: flight.photo!.flightPhoto!, defaultFilename: "DefaultBoardingPass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
            }
            if flight.airlineWebsite != "" {
                Section(header: Text("Airline Website")) {
                    HStack {
                        Link(destination: URL(string: flight.airlineWebsite!)!) {
                            HStack {
                                Image(systemName: "globe")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                    .foregroundColor(.blue)
                                Text("Show Airline's Website")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }   // End of Form
        .navigationBarTitle(Text("Flight Details"), displayMode: .inline)
        .font(.system(size: 14))
       
    }   // End of body
    
    // Converts the departure date into a more user-friendly, readable format.
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
    // Converts the departure date into a more user-friendly, readable format.
    var fullArrivalDate: String {
        let stringDate = flight.arrivalDateTime!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyy-MM-dd 'at' HH:mm:ss"
        let flightDate = dateFormatter.date(from: stringDate)
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.locale = Locale(identifier: "en_US")
        newDateFormatter.dateFormat = "E, MMM d, yyyy 'at' h:mm a"
        return newDateFormatter.string(from: flightDate!)
    }
    
    // Displays the flight cost in the correct format
    var flightCost: Text {
        let costOfFlight = flight.cost!.doubleValue

        // Add thousand separators to trip cost
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSize = 3

        let flightCostString = "$" + numberFormatter.string(from: costOfFlight as NSNumber)!
        return Text(flightCostString)
    }
    
    // Function that determines whether a flight is before or after today's date.
    func isUpcomingFlight(flight: Flight) -> Bool {
        let stringDate = flight.departureDateTime!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyy-MM-dd 'at' HH:mm:ss"
        let flightDate = dateFormatter.date(from: stringDate)
        
        let today = Date()
        
        if (flightDate! > today) {
            return true
        } else {
            return false
        }
    }
}
