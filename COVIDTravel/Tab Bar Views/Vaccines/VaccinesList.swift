//
//  VaccinesList.swift
//  CovidTravel
//
//  Created by James Kim on 4/19/21.
//  Copyright © 2021 James Kim. All rights reserved.
//

import SwiftUI

struct VaccinesList: View {
    var body : some View {
        
            List {
                ForEach(0..<vaccinesFoundList.count, id: \.self) { index in
                    NavigationLink(destination: VaccineDetails(vaccine: vaccinesFoundList[index])) {
                        VaccineItem(vaccine: vaccinesFoundList[index])
                    }
                }
            }
            .navigationBarTitle(Text("Search Results"), displayMode: .inline)

        
    } // End of body
        
}
