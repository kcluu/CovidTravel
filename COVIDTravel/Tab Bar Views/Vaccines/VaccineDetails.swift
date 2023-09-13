//
//  VaccineDetails.swift
//  CovidTravel
//
//  Created by James Kim on 4/19/21.
//  Copyright © 2021 James Kim. All rights reserved.
//

import SwiftUI
import MapKit

struct VaccineDetails: View {
    
    // Input Parameter
    let vaccine: Vaccine
    
    @State private var selectedMapTypeIndex = 0
    var mapTypes = ["Standard", "Satellite", "Hybrid"]
    
    var body: some View {
        Form {
            
            Section(header: Text("Provider")) {
                HStack {
                    getImageFromUrl(url: "https://logo.clearbit.com/\(vaccine.providerName).com", defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80.0)
                    Text("\(vaccine.providerName)")
                }
                
            }
            
            Section(header: Text("Area Location")) {
                Text("\(vaccine.city), \(vaccine.state)")
            }
            
            Section(header: Text("Vaccine Type")) {
                HStack {
                    
                    if vaccine.vaccineType == "moderna" {
                    getImageFromUrl(url: "https://logo.clearbit.com/modernatx.com", defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40.0)
                    }
                    else {
                        getImageFromUrl(url: "https://logo.clearbit.com/\(vaccine.vaccineType).com", defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40.0)
                    }
                    Text("\(vaccine.vaccineType)")
                }
                
            }
            
            Section(header: Text("Address of Provider")) {
                
                if !vaccine.address.isEmpty && vaccine.address != "Unavailable" {
                    Text("\(vaccine.address), \(vaccine.city), \(vaccine.state)")
                }
                else {
                    Text("Unavailable")
                }
            }
            
            // Map type selection section
            Section(header: Text("Select Map Type")) {
                
                Picker("Select Map Type", selection: $selectedMapTypeIndex) {
                    ForEach(0 ..< mapTypes.count, id: \.self) { index in
                        Text(self.mapTypes[index]).tag(index)
                    }
                }
                .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Navigate to location on map
                
                NavigationLink(destination: providerLocationOnMap) {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                        Text("Show Vaccine Provider on Map")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(.blue)
                }
                .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
            }
            
            // If empty dont display
            if vaccine.url != "Unavailable" {
                
                Section(header: Text("Provider Website")) {
                    
                    Link(destination: URL(string: vaccine.url)!) {
                        HStack {
                            Image(systemName: "globe")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Provider Website")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                    
                }
            }
            
            Section(header: Text("Availablility of Vaccines")) {
                
                if vaccine.hasVaccine {
                    Text("There are vaccines available at this location.")
                }
                else {
                    Text("There are currently NO vaccines available at this time. Please check provider's website for updates.")
                }
            }
            
            Section(header: Text("Availablility of Appointments")) {
                
                if vaccine.appointmentsAvailable {
                    Text("You may make appointments at this location.")
                }
                else {
                    Text("Appointments are not available at this location.")
                }
            }
            
            
            
            
        }   // End of Form
        .navigationBarTitle(Text("Vaccines Available at \(vaccine.providerName)"), displayMode: .inline)
        
        
    }
    
    // Method to view location on map
    var providerLocationOnMap: some View {
        
        var mapType: MKMapType
        
        switch selectedMapTypeIndex {
        case 0:
            mapType = MKMapType.standard
        case 1:
            mapType = MKMapType.satellite
        case 2:
            mapType = MKMapType.hybrid
        default:
            fatalError("Map type is out of range!")
        }
        
        return AnyView(MapView(mapType: mapType, latitude: vaccine.longitude, longitude: vaccine.latitude, delta: 3000.0, deltaUnit: "meters", annotationTitle: "\(vaccine.providerName)", annotationSubtitle: "\(vaccine.city), \(vaccine.state)"))
    }
    
}


