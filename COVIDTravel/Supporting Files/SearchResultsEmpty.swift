//
//  SearchResultsEmpty.swift
//  Covid19
//
//  Created by Yongjae Lim on 4/15/21.
//  Copyright © 2021 Yongjae Lim. All rights reserved.
//

import SwiftUI

struct SearchResultsEmpty: View {
    var body: some View {
        ZStack {
            Color(red: 1.0, green: 1.0, blue: 240/255).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .imageScale(.large)
                    .font(Font.title.weight(.medium))
                    .foregroundColor(.red)
                    .padding()
                Text("Database Search Produced No Results!\n\nDatabase search did not return any value for the given query!")
                    .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around
                    .multilineTextAlignment(.center)
                    .padding()
            } // End of VStack
        }
    }
}

struct SearchResultsEmpty_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsEmpty()
    }
}
