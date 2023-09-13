//
//  FindVaccines.swift
//  CovidTravel
//
//  Created by James Kim on 4/19/21.
//  Copyright © 2021 James Kim. All rights reserved.
//

import SwiftUI

struct FindVaccines: View {
    
    @State private var searchFieldValue = ""
    @State private var showSearchFieldEmptyAlert = false
    @State private var searchCompleted = false
    
    @State private var selectedPicker = 0
    
    // Categories List
    let states = ["Alabama",
                  "Alaska",
                  "Arizona",
                  "Arkansas",
                  "California",
                  "Colorado",
                  "Connecticut",
                  "Delaware",
                  "Florida",
                  "Georgia",
                  "Hawaii",
                  "Idaho",
                  "Illinois",
                  "Indiana",
                  "Iowa",
                  "Kansas",
                  "Kentucky",
                  "Louisiana",
                  "Maine",
                  "Maryland",
                  "Massachusetts",
                  "Michigan",
                  "Minnesota",
                  "Mississippi",
                  "Missouri",
                  "Montana",
                  "Nebraska",
                  "Nevada",
                  "New Hampshire",
                  "New Jersey",
                  "New Mexico",
                  "New York",
                  "North Carolina",
                  "North Dakota",
                  "Ohio",
                  "Oklahoma",
                  "Oregon",
                  "Pennsylvania",
                  "Rhode Island",
                  "South Carolina",
                  "South Dakota",
                  "Tennessee",
                  "Texas",
                  "Utah",
                  "Vermont",
                  "Virginia",
                  "Washington",
                  "West Virginia",
                  "Wisconsin",
                  "Wyoming"]
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Select a State")) {
                    Picker("", selection: $selectedPicker) {
                        ForEach(0 ..< states.count, id: \.self) {
                            Text(self.states[$0])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                }
                
                
                Section(header:
                            Text("Enter City Name")
                ) {
                    HStack {
                        TextField("Enter Search Query", text: $searchFieldValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                            .frame(width: 240, height: 36)
                        
                        // Button to clear the text field
                        Button(action: {
                            self.searchFieldValue = ""
                            self.showSearchFieldEmptyAlert = false
                            self.searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                        .alert(isPresented: $showSearchFieldEmptyAlert, content: { self.searchFieldEmptyAlert })
                        
                    }   // End of HStack
                    .padding(.horizontal)
                }
                
                Section(header: Text("Search Available Vaccines")) {
                    HStack {
                        Button(action: {
                            // Remove spaces, if any, at the beginning and at the end of the entered search query string
                            let queryTrimmed = self.searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            if (queryTrimmed.isEmpty) {
                                self.showSearchFieldEmptyAlert = true
                            } else {
                                self.searchApi()
                                self.searchCompleted = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "text.magnifyingglass")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                    .foregroundColor(.blue)
                                Text(self.searchCompleted ? "Search Completed" : "Search")
                            }
                        }
                        .frame(width: 240, height: 36, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.black, lineWidth: 1)
                        )
                    }   // End of HStack
                    .padding(.horizontal)
                }
                
                if searchCompleted {
                    Section(header: Text("Show List of Vaccine Providers")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "creditcard.circle")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                    .foregroundColor(.blue)
                                Text("Show List of Vaccine Providers")
                                    .font(.system(size: 16))
                            }
                        }
                    }
                }
                
            }   // End of Form
            .navigationBarTitle(Text("Find Vaccines in Your Area"), displayMode: .inline)
            
        }   // End of NavigationView
        .customNavigationViewStyle()  // Given in NavigationStyle.swift
        
    }   // End of body
    
    func searchApi() {
        obtainVaccineDataFromApi(stateName: statesDictionary[states[selectedPicker]]!, cityName: self.searchFieldValue)
    }
    
    
    /*
     ---------------------------------
     MARK: - Vaccine Not Found Message
     ---------------------------------
     */
    var notFoundMessage: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.red)
                .padding()
            Text("No Available Providers for Covid-19 Vaccines Found!\n\nThe entered city \(self.searchFieldValue) in the state of \(states[selectedPicker]) did not return any movie from the API! Please enter another search query")
                .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(red: 1.0, green: 1.0, blue: 240/255))     // Ivory color
    }
    
    /*
     ---------------------------
     MARK: - Show Search Results
     ---------------------------
     */
    var showSearchResults: some View {
        
        if vaccinesFoundList.isEmpty {
            return AnyView(notFoundMessage)
        }
        
        return AnyView(VaccinesList())
    }
    
    var searchFieldEmptyAlert: Alert {
        Alert(title: Text("City Name Field is Empty!"),
              message: Text("Please enter a search query!"),
              dismissButton: .default(Text("OK")))
    }
    
}

struct FindVaccines_Previews: PreviewProvider {
    static var previews: some View {
        FindVaccines()
    }
}

