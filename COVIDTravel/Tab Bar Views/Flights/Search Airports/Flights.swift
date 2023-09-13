//
//  Flights.swift
//  Covid19
//
//  Created by Yongjae Lim on 4/15/21.
//  Copyright © 2021 Yongjae Lim. All rights reserved.
//

import SwiftUI

struct Flights: View {
    
    let filename: String
    // subscribe to changes UserData
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Image(filename)
                    .resizable()
                    .frame(width: 300, height: 300)
                NavigationLink(destination: PlannedFlightsList()) {
                    HStack {
                        Image(systemName: "list.bullet.rectangle")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                        Text("My Planned Flights")
                    } // End of HStack
                } // End of Navigation Link
                NavigationLink(destination: SearchAirports()) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                        Text("Search Airports")
                    } // End of HStack
                } // End of Navigation Link
                
                NavigationLink(destination: BookAFlight()) {
                    HStack {
                        Image(systemName: "bookmark.fill")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                        Text("Book a Flight")
                    } // End of HStack
                } // End of Navigation Link
                
            } // End of VStack
            .padding(.bottom, 250)
            .navigationBarTitle("Find a Flight", displayMode: .inline)
        } // End of Navigation View

    }
}

struct Flights_Previews: PreviewProvider {
    static var previews: some View {
        Flights(filename: "SearchAirports")
    }
}
