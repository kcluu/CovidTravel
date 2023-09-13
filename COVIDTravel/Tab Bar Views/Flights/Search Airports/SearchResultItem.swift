//
//  SearchResultItem.swift
//  Covid19
//
//  Created by Yongjae Lim on 4/15/21.
//  Copyright © 2021 Yongjae Lim. All rights reserved.
//

import SwiftUI

struct SearchResultItem: View {
    
    // ❎ Input parameter: Core Data Airport Entity instance reference
    let airport: Airport
    
    var body: some View {
        HStack {
            Image(systemName: "airplane.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60.0)
            VStack(alignment: .leading) {
                Text(airport.name ?? "")
                Text(airport.iataCode ?? "")
                Text(airport.city ?? "")
            }
            .font(.system(size: 14))
        }
    }
}
