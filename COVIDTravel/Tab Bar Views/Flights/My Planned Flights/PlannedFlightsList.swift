//
//  PlannedFlightsList.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/29/21.
//

import SwiftUI

struct PlannedFlightsList: View {
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
   
    // ❎ CoreData FetchRequest returning all Flight entities in the database
    @FetchRequest(fetchRequest: Flight.allFlightsFetchRequest()) var allFlights: FetchedResults<Flight>
   
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Flight entities with all the changes.
    @EnvironmentObject var userData: UserData
   
    var body: some View {
        Text("Your Upcoming Flights")
            .fontWeight(.bold)
            .frame(width: UIScreen.main.bounds.size.width, height: 40, alignment: .center)
            .background(Rectangle().fill(Color.red))
            .foregroundColor(.white)
            List {
                /*
                 Each NSManagedObject has internally assigned unique ObjectIdentifier
                 used by ForEach to display the Flights in a dynamic scrollable list.
                 */
                ForEach(self.allFlights) { aFlight in
                    Group {
                        if isUpcomingFlight(flight: aFlight) {
                            NavigationLink(destination: PlannedFlightDetails(flight: aFlight)) {
                                PlannedFlightItem(flight: aFlight)
                            }
                        }
                    }
                }
                .onDelete(perform: delete)
               
            }   // End of List
        Text("Your Past Flights")
            .fontWeight(.bold)
            .frame(width: UIScreen.main.bounds.size.width, height: 40, alignment: .center)
            .background(Rectangle().fill(Color.gray))
            .foregroundColor(.white)
            List {
                /*
                 Each NSManagedObject has internally assigned unique ObjectIdentifier
                 used by ForEach to display the Flights in a dynamic scrollable list.
                 */
                ForEach(self.allFlights) { aFlight in
                    Group {
                        if !isUpcomingFlight(flight: aFlight) {
                            NavigationLink(destination: PlannedFlightDetails(flight: aFlight)) {
                                PlannedFlightItem(flight: aFlight)
                            }
                        }
                    }

                }
                .onDelete(perform: delete)
               
            }   // End of List
            .navigationBarTitle(Text("My Planned Flights"), displayMode: .inline)
           
            // Place the Edit button on left and Add (+) button on right of the navigation bar
            .navigationBarItems(leading: EditButton(), trailing:
                NavigationLink(destination: AddPlannedFlight()) {
                    Image(systemName: "plus")
                })
           
            // Use single column navigation view for iPhone and iPad
            .navigationViewStyle(StackNavigationViewStyle())
    }
   
    /*
     ----------------------------
     MARK: - Delete Selected Flight
     ----------------------------
     */
    func delete(at offsets: IndexSet) {
       
        let flightToDelete = self.allFlights[offsets.first!]
       
        // ❎ CoreData Delete operation
        self.managedObjectContext.delete(flightToDelete)
 
        // ❎ CoreData Save operation
        do {
          try self.managedObjectContext.save()
        } catch {
          print("Unable to delete selected flight!")
        }
    }
    
    // Function that determines if a planned flight is before or after today's date.
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

struct PlannedFlightsList_Previews: PreviewProvider {
    static var previews: some View {
        PlannedFlightsList()
    }
}
