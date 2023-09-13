//
//  Restrictions.swift
//  Covid19
//
//  Created by Yongjae Lim on 4/15/21.
//  Copyright © 2021 Yongjae Lim. All rights reserved.
//

import SwiftUI
 
fileprivate var selectedState = stateStructList[0]
 
struct Restrictions: View {
   
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
   
    @State private var showStateInfoAlert = false
   
    // Fit as many images per row as possible with minimum image width of 100 points each.
    // spacing defines spacing between columns
    let columns = [ GridItem(.adaptive(minimum: 100), spacing: 3) ]
   
    var body: some View {
        ScrollView {
            // spacing defines spacing between rows
            LazyVGrid(columns: columns, spacing: 3) {
                // 🔴 Specifying id: \.self is critically important to prevent photos being listed as out of order
                ForEach(self.userData.statesList, id: \.self) { state in
                    VStack {
                        Image("\(state.photoName)")
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                selectedState = state
                                self.showStateInfoAlert = true
                            }
                        Text(state.name)
                    }
                }
            }   // End of LazyVGrid
                .padding()
           
        }   // End of ScrollView
            .alert(isPresented: $showStateInfoAlert, content: { self.stateInfoAlert })
    }
   
    var stateInfoAlert: Alert {
        Alert(title: Text(selectedState.name),
              message: Text(selectedState.restrictions),
              dismissButton: .default(Text("OK")) )
    }
   
}
 
struct Restrictions_Previews: PreviewProvider {
    static var previews: some View {
        Restrictions()
    }
}
