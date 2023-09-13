//
//  SearchResultDetails.swift
//  Covid19
//
//  Created by Yongjae Lim on 4/15/21.
//  Copyright © 2021 Yongjae Lim. All rights reserved.
//

import SwiftUI
import MapKit

struct SearchResultDetails: View {
    
    // ❎ Input parameter: Core Data Airport Entity instance reference
    let airport: Airport
    
    var body: some View {
        Form {
            Section(header: Text("Airport Name")) {
                Text(airport.name ?? "")
            }
            
            Section(header: Text("IATA Code")) {
                Text(airport.iataCode ?? "")
            }
            
            Section(header: Text("City")) {
                Text(airport.city ?? "")
            }
            
            Section(header: Text("Country")) {
                Text(airport.country ?? "")
            }
            
            Section(header: Text("Show Airport Location On Map")) {
                NavigationLink(destination: airportLocationOnMap) {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                        Text("Show Airport Location on Map")
                            .font(.system(size: 16))
                    }
                }
                .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
            }
        } // End of Form
        .navigationBarTitle(Text("Airport Details"), displayMode: .inline)
        .font(.system(size: 14))
    } // End of Body
    
    var airportLocationOnMap: some View {
        
        let latitude = airport.latitude as! Double
        let longitude = airport.longitude as! Double
        
        return AnyView(MapView(mapType: MKMapType.standard, latitude: latitude, longitude: longitude, delta: 1000000.0, deltaUnit: "meter", annotationTitle: airport.name!, annotationSubtitle: airport.iataCode!)
                        .navigationBarTitle(Text(airport.iataCode ?? ""), displayMode: .inline)
                        .edgesIgnoringSafeArea(.all) )
            
    }
}
