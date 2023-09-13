//
//  SearchAirports.swift
//  Covid19
//
//  Created by Yongjae Lim on 4/15/21.
//  Copyright © 2021 Yongjae Lim. All rights reserved.
//

import SwiftUI
import CoreData

// Implementation of Error Alert with help from:
// https://medium.com/swlh/create-a-slide-down-error-alert-with-swiftui-and-animations-2c97237fc9e1
// By Lawrence Tan
 
// Global Variables
var searchCategory = ""
var searchQuery = ""

extension AnyTransition {
    static var fadeAndSlide: AnyTransition {
        AnyTransition.opacity.combined(with: .move(edge: .top))
    }
}


 
struct SearchAirports: View {
    
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
   
    let searchCategoriesList = ["City", "Airport Name"]
   
    @State private var selectedSearchCategoryIndex = 0
    @State private var citySearchQuery = ""
    @State private var airportSearchQuery = ""
    
    @EnvironmentObject var userData: UserData
    
    @State private var selectedIndex = 5
    
    @State private var showMissingInputLabel = false
        
        init() {
            UINavigationBar.appearance().largeTitleTextAttributes = [
                .foregroundColor : UIColor.white,
            ]
        }
    
    var missingInputLabel: some View {
            HStack {
                Spacer()
                if selectedSearchCategoryIndex == 0 {
                    Text("Enter a CITY NAME!")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                } else {
                    Text("Enter an Airport NAME!")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                }
                Spacer()
            }
            .frame(height: 50.0)
            .background(Color.red)
        }
    
    var body: some View {
        if showMissingInputLabel {
            missingInputLabel.transition(.asymmetric(insertion: .fadeAndSlide, removal: .fadeAndSlide))
        }
        Form {
            
            Section(header: Text("Select a Search Category")) {
                
                Picker("", selection: $selectedSearchCategoryIndex) {
                    ForEach(0 ..< searchCategoriesList.count, id: \.self) {
                        Text(self.searchCategoriesList[$0])
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                
            }
            if self.selectedSearchCategoryIndex == 0 {
                Section(header: Text("Enter a City Name")) {
                    VStack {
                        HStack {
                            TextField("Enter a city name", text: $citySearchQuery)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .frame(minWidth: 260, maxWidth: 500, alignment: .leading)
                            
                            // Button to clear the text field
                            Button(action: {
                                self.citySearchQuery = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }   // End of HStack
                    }   // End of VStack
                }
            }
            if self.selectedSearchCategoryIndex == 1 {
                Section(header: Text("Enter an airport name")) {
                    HStack {
                        TextField("Enter an airport name", text: $airportSearchQuery)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .frame(minWidth: 260, maxWidth: 500, alignment: .leading)
                        
                        // Button to clear the text field
                        Button(action: {
                            self.airportSearchQuery = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                }
            }
            if selectedSearchCategoryIndex == 0 {
                if !citySearchQuery.isEmpty {
                    Section(header: Text("Show Search Results")) {
                        NavigationLink(destination: showSearchResults()) {
                            HStack {
                                Image(systemName: "list.bullet")
                                Text("Show Search Results")
                                    .font(.headline)
                            }
                        }
                    }
                } else {
                    Section(header: Text("Show Search Results")) {
                        HStack {
                            Button(action: {
                                showAlerts()
                            }) {
                                HStack {
                                    Image(systemName: "list.bullet")
                                        .foregroundColor(.black)
                                    Text("Show Search Results")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                            }
                        }   // End of HStack
                    }

                }
            } else {
                if !airportSearchQuery.isEmpty {
                    Section(header: Text("Show Search Results")) {
                        NavigationLink(destination: showSearchResults()) {
                            HStack {
                                Image(systemName: "list.bullet")
                                Text("Show Search Results")
                                    .font(.headline)
                            }
                        }
                    }
                } else {
                    Section(header: Text("Show Search Results")) {
                        HStack {
                            Button(action: {
                                showAlerts()
                            }) {
                                HStack {
                                    Image(systemName: "list.bullet")
                                        .foregroundColor(.black)
                                    Text("Show Search Results")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                            }
                        }   // End of HStack
                    }
                }
            }
        }   // End of Form
        .navigationBarTitle(Text("Search Airports"), displayMode: .inline)
        // Use single column navigation view for iPhone and iPad
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func animateAndDelayWithSeconds(_ seconds: TimeInterval, action: @escaping () -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                withAnimation {
                    action()
                }
            }
        }
   
    func showAlerts() {
        if selectedSearchCategoryIndex == 0 {
            if (citySearchQuery.isEmpty) {
                self.animateAndDelayWithSeconds(1) { self.showMissingInputLabel = true }
                self.animateAndDelayWithSeconds(3) { self.showMissingInputLabel = false }
            }
        } else {
            if (airportSearchQuery.isEmpty) {
                self.animateAndDelayWithSeconds(1) { self.showMissingInputLabel = true }
                self.animateAndDelayWithSeconds(3) { self.showMissingInputLabel = false }
            }
        }
    }
    
    func showSearchResults() -> some View {
 
        if selectedSearchCategoryIndex == 0 {
            searchCategory = "City"
            searchQuery = citySearchQuery
        } else {
            searchCategory = "Airport Name"
            searchQuery = airportSearchQuery
        }
       
        return AnyView(SearchResultsList())
    }
   
    var missingSearchQueryMessage: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.red)
                .padding()
            Text("Search Query Missing!\nPlease enter a search query to be able to search the database!")
                .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(red: 1.0, green: 1.0, blue: 240/255))     // Ivory color
    }
 
}
 
struct SearchAirports_Previews: PreviewProvider {
    static var previews: some View {
        SearchAirports()
    }
}
