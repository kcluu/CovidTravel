//
//  VaccineItem.swift
//  CovidTravel
//
//  Created by James Kim on 4/19/21.
//  Copyright © 2021 James Kim. All rights reserved.
//

import SwiftUI

struct VaccineItem: View {
    
    // Input Parameter
    let vaccine: Vaccine
    
    var body: some View {
        HStack {
            
            getImageFromUrl(url: "https://logo.clearbit.com/\(vaccine.providerName).com", defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70.0)
            
            VStack(alignment: .leading) {
                Text("Provider: \(vaccine.providerName)")
                if !vaccine.address.isEmpty && vaccine.address != "Unavailable" {
                    Text("Location \(vaccine.address), \(vaccine.city), \(vaccine.state)")
                }
                else {
                    Text("Location \(vaccine.city), \(vaccine.state)")
                }
                Text("Type of Vaccine: \(vaccine.vaccineType)")
            }
            .font(.system(size: 14))
        }
        
        
    }
    
}


