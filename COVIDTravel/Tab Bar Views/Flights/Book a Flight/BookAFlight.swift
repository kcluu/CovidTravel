//
//  BookAFlight.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/17/21.
//

import SwiftUI

struct BookAFlight: View {
    // User input
    @State private var airportDeparture = ""
    @State private var missingAirportDeparture = false
    @State private var airportArrival = ""
    @State private var missingAirportArrival = false
    @State private var selectedTypeIndex = 0
    let tripTypeList = ["Round-Trip", "One-Way"]
    @State private var departureDate = Date()
    @State private var returnDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    @State private var numOfAdults = 0
    @State private var numOfYouths = 0
    @State private var numOfChildren = 0
    @State private var numOfInfants = 0
    @State private var missingPassengers = false
    @State private var selectedClassIndex = 0
    let classList = ["Economy", "Premium Economy", "Business", "First"]
    @State private var searchCompleted = false
    @State private var searchCompleted2 = false
    
    // Alerts
    @State private var showMissingInputDataAlert = false
    
    // Date
    var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .long     // e.g., August 14, 2020
            return formatter
        }
       
        var dateClosedRange: ClosedRange<Date> {
            // Set minimum date to 40 years earlier than the current year
            let minDate = Calendar.current.date(byAdding: .year, value: -40, to: Date())!
           
            // Set maximum date to 10 years later than the current year
            let maxDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())!
            return minDate...maxDate
        }
    
    // Passenger Stepper Calculations
    let maxTotalPassengers = 8
    @State private var currTotal = 0
    @State private var maxAdultsRange = 8
    @State private var maxYouthsRange = 8
    @State private var maxChildrenRange = 8
    @State private var maxInfantsRange = 8
    
    var body: some View {
            Form {
                Section(header: aiportDepartureHeader) {
                    HStack {
                        TextField("Enter Airport Code for Departure", text: $airportDeparture)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .autocapitalization(.allCharacters)
                            .disabled(airportDeparture.count > 2)
                        
                        // Button to clear the text field
                        Button(action: {
                            self.airportDeparture = ""
                            self.searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                        .alert(isPresented: $showMissingInputDataAlert, content: {
                            self.missingDataAlert
                        })
                    }
                }
                Section(header: aiportArrivalHeader) {
                    HStack {
                        TextField("Enter Airport Code for Arrival", text: $airportArrival)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .autocapitalization(.allCharacters)
                            .disabled(airportArrival.count > 2)
                        
                        // Button to clear the text field
                        Button(action: {
                            self.airportArrival = ""
                            self.searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Select Trip Type")) {
                    Picker("", selection: $selectedTypeIndex) {
                        ForEach(0 ..< tripTypeList.count, id: \.self) {
                            Text(self.tripTypeList[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .onChange(of: selectedTypeIndex) { newValue in
                    self.searchCompleted = false
                }
                Section(header: Text("Select Departure Date")) {
                    DatePicker(selection: $departureDate, in: dateClosedRange, displayedComponents: .date) {
                        Text("Departure Date: ")
                    }
                    .onChange(of: departureDate) { newValue in
                        self.searchCompleted = false
                    }
                }
                if (selectedTypeIndex == 0) {
                    Section(header: Text("Select Return Date")) {
                        DatePicker(selection: $returnDate, in: dateClosedRange, displayedComponents: .date) {
                            Text("Return Date: ")
                        }
                        .onChange(of: returnDate) { newValue in
                            self.searchCompleted = false
                        }
                    }
                }
                Section(header: passengersHeader) {
                    
                    // Stepper changes the value stored in numOfAdults and accepts ranges from 0 to maxAdultsRange
                    Stepper(value: $numOfAdults, in: 0...maxAdultsRange) { // maxAdultsRange updates according to
                                                                           // each Stepper's .onChange action.
                        Text("\(numOfAdults) Adults")
                    }
                    // Responsible for ensuring the user does not enter more than a total of 8 passengers across
                    // all categories.
                    .onChange(of: numOfAdults) { newValue in
                        // Update the total number of passengers, maximum number of adults/youths/children/infants
                        // after each increment/decrement of the Stepper for Adult passengers.
                        let currTotalAdults = numOfYouths + numOfChildren + numOfInfants
                        maxAdultsRange = maxTotalPassengers - currTotalAdults
                        let currTotalYouths = numOfAdults + numOfChildren + numOfInfants
                        maxYouthsRange = maxTotalPassengers - currTotalYouths
                        let currTotalChildren = numOfYouths + numOfAdults + numOfInfants
                        maxChildrenRange = maxTotalPassengers - currTotalChildren
                        let currTotalInfants = numOfYouths + numOfChildren + numOfAdults
                        maxInfantsRange = maxTotalPassengers - currTotalInfants
                        self.searchCompleted = false
                    }
                    Stepper(value: $numOfYouths, in: 0...maxYouthsRange) { // maxYouthsRange updates according to each Stepper's change.
                        Text("\(numOfYouths) Youths")
                    }
                    // Responsible for ensuring the user does not enter more than a total of 8 passengers across all categories.
                    .onChange(of: numOfYouths) { newValue in
                        // Update the total number of passengers, maximum number of adults/youths/children/infants after each increment/decrement of the Stepper for Youth passengers.
                        let currTotalAdults = numOfYouths + numOfChildren + numOfInfants
                        maxAdultsRange = maxTotalPassengers - currTotalAdults
                        let currTotalYouths = numOfAdults + numOfChildren + numOfInfants
                        maxYouthsRange = maxTotalPassengers - currTotalYouths
                        let currTotalChildren = numOfYouths + numOfAdults + numOfInfants
                        maxChildrenRange = maxTotalPassengers - currTotalChildren
                        let currTotalInfants = numOfYouths + numOfChildren + numOfAdults
                        maxInfantsRange = maxTotalPassengers - currTotalInfants
                        self.searchCompleted = false
                    }
                    Stepper(value: $numOfChildren, in: 0...maxChildrenRange) { // maxChildrenRange updates according to each Stepper's change.
                        Text("\(numOfChildren) Children")
                    }
                    // Responsible for ensuring the user does not enter more than a total of 8 passengers across all categories.
                    .onChange(of: numOfChildren) { newValue in
                        // Update the total number of passengers, maximum number of adults/youths/children/infants after each increment/decrement of the Stepper for Children passengers.
                        let currTotalAdults = numOfYouths + numOfChildren + numOfInfants
                        maxAdultsRange = maxTotalPassengers - currTotalAdults
                        let currTotalYouths = numOfAdults + numOfChildren + numOfInfants
                        maxYouthsRange = maxTotalPassengers - currTotalYouths
                        let currTotalChildren = numOfYouths + numOfAdults + numOfInfants
                        maxChildrenRange = maxTotalPassengers - currTotalChildren
                        let currTotalInfants = numOfYouths + numOfChildren + numOfAdults
                        maxInfantsRange = maxTotalPassengers - currTotalInfants
                        self.searchCompleted = false
                    }
                    Stepper(value: $numOfInfants, in: 0...maxInfantsRange) { // maxInfantsRange updates according to each Stepper's change.
                        Text("\(numOfInfants) Lap Infants")
                    }
                    // Responsible for ensuring the user does not enter more than a total of 8 passengers across all categories.
                    .onChange(of: numOfInfants) { newValue in
                        // Update the total number of passengers, maximum number of adults/youths/children/infants after each increment/decrement of the Stepper for Infant passengers.
                        let currTotalAdults = numOfYouths + numOfChildren + numOfInfants
                        maxAdultsRange = maxTotalPassengers - currTotalAdults
                        let currTotalYouths = numOfAdults + numOfChildren + numOfInfants
                        maxYouthsRange = maxTotalPassengers - currTotalYouths
                        let currTotalChildren = numOfYouths + numOfAdults + numOfInfants
                        maxChildrenRange = maxTotalPassengers - currTotalChildren
                        let currTotalInfants = numOfYouths + numOfChildren + numOfAdults
                        maxInfantsRange = maxTotalPassengers - currTotalInfants
                        self.searchCompleted = false
                    }
                }
                Section(header: Text("Select a Flight Class")) {
                    Picker("", selection: $selectedClassIndex) {
                                    ForEach(0 ..< classList.count, id: \.self) {
                                        Text(self.classList[$0])
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                    .onChange(of: selectedClassIndex) { newValue in
                        self.searchCompleted = false
                    }
                }
                if (selectedTypeIndex == 0) {
                    Section(header: Text("Search Flights")) {
                        HStack {
                            Button(action: {
                                if self.inputDataValidated() {
                                    self.searchCompleted = true
                                } else {
                                    self.showMissingInputDataAlert = true
                                    self.searchCompleted = false
                                }
                            }) {
                                Text(self.searchCompleted ? "Search Completed" : "Search")
                            }
                            .frame(width: 240, height: 36, alignment: .center)
                            .background(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.black, lineWidth: 1))
                        } // End of HStack
                    }
                    if searchCompleted {
                        Section(header: Text("View Flights Found")) {
                            Link(destination: URL(string: flightUrl)!) {
                                HStack {
                                    Image(systemName: "globe")
                                        .imageScale(.medium)
                                        .font(Font.title.weight(.regular))
                                        .foregroundColor(.blue)
                                    Text("View Flights Found")
                                        .font(.system(size: 16))
                                }
                                .frame(minWidth: 300, maxWidth: 500)
                            }
                        }
                    }
                } else {
                    Section(header: Text("Search Flights")) {
                        HStack {
                            Button(action: {
                                if self.inputDataValidated() {
                                    self.searchCompleted2 = true
                                } else {
                                    self.showMissingInputDataAlert = true
                                    self.searchCompleted2 = false
                                }
                            }) {
                                Text(self.searchCompleted2 ? "Search Completed" : "Search")
                            }
                            .frame(width: 240, height: 36, alignment: .center)
                            .background(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.black, lineWidth: 1))
                        } // End of HStack
                    }
                    if (searchCompleted2) {
                        Section(header: Text("View Flights Found")) {
                            Link(destination: URL(string: flightUrl)!) {
                                HStack {
                                    Image(systemName: "globe")
                                        .imageScale(.medium)
                                        .font(Font.title.weight(.regular))
                                        .foregroundColor(.blue)
                                    Text("View Flights Found")
                                        .font(.system(size: 16))
                                }
                                .frame(minWidth: 300, maxWidth: 500)
                            }
                        }
                    }
                }
            } // End of Form
            .navigationBarTitle(Text("Book a Flight"), displayMode: .inline)
            .font(.system(size: 14))
    }
    
    // Displays the heading for airport departure depending if the user has an error there or not.
    var aiportDepartureHeader: Text {
        if (missingAirportDeparture) {
            return Text("Enter Airport Code for Departure")
                .foregroundColor(Color.red)
        } else {
            return Text("Enter Airport Code for Departure")
        }
    }
    
    // Displays the heading for airport arrival depending if the user has an error there or not.
    var aiportArrivalHeader: Text {
        if (missingAirportArrival) {
            return Text("Enter Airport Code for Arrival")
                .foregroundColor(Color.red)
        } else {
            return Text("Enter Airport Code for Arrival")
        }
    }
    
    // Displays the heading for passengers depending if the user has an error there or not.
    var passengersHeader: Text {
        if (missingPassengers) {
            return Text("Enter Number of Passengers")
                .foregroundColor(Color.red)
        } else {
            return Text("Enter Number of Passengers")
        }
    }
    
    /*
     --------------------------------
     MARK: - Missing Airport Departure Alert
     --------------------------------
     */
    var missingDataAlert: Alert {
        Alert(title: Text("Missing Information!"),
              message: Text("Please fill out the missing information and try again!"),
              dismissButton: .default(Text("OK")) )
        /*
        Tapping OK resets @State var showMissingInputDataAlert to false.
        */
    }
    /*
     -----------------------------
     MARK: - Input Data Validation
     -----------------------------
     */
    func inputDataValidated() -> Bool {
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let departureQuery = self.airportDeparture.trimmingCharacters(in: .whitespacesAndNewlines)
        if (selectedTypeIndex == 0) {
            let arrivalQuery = self.airportArrival.trimmingCharacters(in: .whitespacesAndNewlines)
            if arrivalQuery.isEmpty {
                missingAirportArrival = true
            } else {
                missingAirportArrival = false
            }
        }
        if departureQuery.isEmpty {
            missingAirportDeparture = true
        } else {
            missingAirportDeparture = false
        }
        if numOfChildren == 0 && numOfInfants == 0 && numOfYouths == 0 && numOfAdults == 0 {
            missingPassengers = true
        } else {
            missingPassengers = false
        }
        
        return !missingPassengers && !missingAirportArrival && !missingAirportDeparture
    }
    
    // Constructs the flight url depending on the user's inputs
    var flightUrl: String {
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let departureDateFormatted = dateFormatter2.string(from: departureDate).replacingOccurrences(of: "-", with: "")
        var returnDateFormatted = ""
        if selectedTypeIndex == 0 {
            returnDateFormatted = dateFormatter2.string(from: returnDate).replacingOccurrences(of: "-", with: "")
        }
        var classFormatted = ""
        if selectedClassIndex == 0 {
            classFormatted = "ECO"
        } else if selectedClassIndex == 1 {
            classFormatted = "PEC"
        } else if selectedClassIndex == 2 {
            classFormatted = "BUS"
        } else {
            classFormatted = "FST"
        }
        if (selectedTypeIndex == 0) { // If the user selected a round trip flight
            return "https://www.priceline.com/m/fly/search/\(airportDeparture)-\(airportArrival)-\(departureDateFormatted)/\(airportArrival)-\(airportDeparture)-\(returnDateFormatted)/?alt-dates=false&cabin-class=\(classFormatted)&num-adults=\(numOfAdults)&num-children=\(numOfChildren)&num-infants=\(numOfInfants)&num-youths=\(numOfYouths)&sbsroute=slice1&search-type=0000&vrid=a80798cdf77b4943d3f661f8e070c3fb"
        } else { // If the user selected a one way flight
            return "https://www.priceline.com/m/fly/search/\(airportDeparture)-\(airportArrival)-\(departureDateFormatted)/?alt-dates=false&cabin-class=\(classFormatted)&num-adults=\(numOfAdults)&num-children=\(numOfChildren)&num-infants=\(numOfInfants)&num-youths=\(numOfYouths)&sbsroute=slice1&search-type=0000&vrid=a80798cdf77b4943d3f661f8e070c3fb"
        }
    }
}

struct BookAFlight_Previews: PreviewProvider {
    static var previews: some View {
        BookAFlight()
    }
}
