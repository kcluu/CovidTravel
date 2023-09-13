//
//  SearchResultsList.swift
//  Covid19
//
//  Created by Yongjae Lim on 4/15/21.
//  Copyright © 2021 Yongjae Lim. All rights reserved.
//

import SwiftUI
 
struct SearchResultsList: View {
   
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    // ❎ CoreData FetchRequest returning filtered Airport entities from the database
    @FetchRequest(fetchRequest: Airport.filteredAirportsFetchRequest(searchCategory: searchCategory, searchQuery: searchQuery)) var filteredAirports: FetchedResults<Airport>
    
   
    var body: some View {
        if self.filteredAirports.isEmpty {
            SearchResultsEmpty()
        } else {
            List {
                /*
                 Each NSManagedObject has internally assigned unique ObjectIdentifier
                 used by ForEach to display the Airports in a dynamic scrollable list.
                 */
                ForEach(self.filteredAirports) { airport in
                    NavigationLink(destination: SearchResultDetails(airport: airport)) {
                        SearchResultItem(airport: airport)
                    }
                }
               
            }   // End of List
            .navigationBarTitle(Text("Airports Found"), displayMode: .inline)
        }   // End of if
    }
}
struct SearchResultsList_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsList()
    }
}
