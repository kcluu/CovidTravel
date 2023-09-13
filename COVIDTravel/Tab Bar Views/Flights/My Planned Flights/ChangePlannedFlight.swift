//
//  ChangePlannedFlight.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/29/21.
//

import SwiftUI

struct ChangePlannedFlight: View {
    // ❎ Input parameter: Core Data Flight Entity instance reference
    let flight: Flight
   
    // Enable this View to be dismissed to go back when the Save button is tapped
    @Environment(\.presentationMode) var presentationMode
   
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
   
    @State private var showChangesSavedAlert = false
   
    // Flight Entity
    @State private var airlineName = ""
    @State private var departureCode = ""
    @State private var departureDateTime = Date()
    @State private var cost = 0.00
    @State private var arrivalCode = ""
    @State private var arrivalDateTime = Date()
    @State private var notes = ""
    @State private var purpose = ""
    @State private var airlineWebsite = ""
   
    // Flight Entity Changes
    @State private var changeAirlineName = false
    @State private var changeDepartureCode = false
    @State private var changeDepartureDateTime = false
    @State private var changeCost = false
    @State private var changeArrivalCode = false
    @State private var changeArrivalDateTime = false
    @State private var changeNotes = false
    @State private var changePurpose = false
    @State private var changeAirlineWebsite = false
    @State private var changeFlightPhoto = false
    
    @State private var departureDateChanged = false
    @State private var arrivalDateChanged = false
    @State private var costChanged = false
   
    // Flight Photo
    @State private var showImagePicker = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 1    // Pick from Photo Library
   
    var photoTakeOrPickChoices = ["Camera", "Photo Library"]
    
    // Date picker
    var dateAndTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyy-MM-dd 'at' HH:mm:ss"
        return formatter
    }
    var dateClosedRange: ClosedRange<Date> {
        // Set minimum date to 20 years earlier than the current year
        let minDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
       
        // Set maximum date to 10 years later than the current year
        let maxDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())!
        return minDate...maxDate
    }
    
    // Define formatter before it is used
        let flightCostFormatter: NumberFormatter = {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 2
            numberFormatter.usesGroupingSeparator = true
            numberFormatter.groupingSize = 3
            return numberFormatter
        }()
   
    var body: some View {
        Form {
            Group {
                Section(header: Text("Airline Name")) {
                    airlineNameSubview
                }
                Section(header: Text("Departure Details")) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Airport Departure Code: ")
                                .fontWeight(.semibold)
                            Text(flight.departureCode ?? "")
                            Button(action: {
                                self.changeDepartureCode.toggle()
                                self.departureCode = ""
                            }) {
                                if self.changeDepartureCode {
                                    Image(systemName: "xmark.circle")
                                        .imageScale(.large)
                                        .foregroundColor(.blue)
                                } else {
                                    Image(systemName: "pencil.circle")
                                        .imageScale(.large)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        if self.changeDepartureCode {
                            TextField("Change airport departure code", text: $departureCode)
                                 .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    HStack {
                        Text("Departure Date: ")
                            .fontWeight(.semibold)
                        Text(fullDepartureDate)
                        Button(action: {
                            self.changeDepartureDateTime.toggle()
                        }) {
                            if self.changeDepartureDateTime {
                                Image(systemName: "xmark.circle")
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "pencil.circle")
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    if self.changeDepartureDateTime {
                        DatePicker(selection: $departureDateTime, in: dateClosedRange, displayedComponents: [.hourAndMinute, .date]
                        ){
                            Text("Select a new departure date")
                            
                        }
                        .onChange(of: departureDateTime) { newValue in
                            departureDateChanged = true
                        }
                    }
                }
                Section(header: Text("Arrival Details")) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Airport Arrival Code: ")
                                .fontWeight(.semibold)
                            Text(flight.arrivalCode ?? "")
                            Button(action: {
                                self.changeArrivalCode.toggle()
                                self.arrivalCode = ""
                            }) {
                                if self.changeArrivalCode {
                                    Image(systemName: "xmark.circle")
                                        .imageScale(.large)
                                        .foregroundColor(.blue)
                                } else {
                                    Image(systemName: "pencil.circle")
                                        .imageScale(.large)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        if self.changeArrivalCode {
                            TextField("Change airport arrival code", text: $arrivalCode)
                                 .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    HStack {
                        Text("Arrival Date: ")
                            .fontWeight(.semibold)
                        Text(fullArrivalDate)
                        Button(action: {
                            self.changeArrivalDateTime.toggle()
                        }) {
                            if self.changeArrivalDateTime {
                                Image(systemName: "xmark.circle")
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "pencil.circle")
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    if self.changeArrivalDateTime {
                        DatePicker(selection: $arrivalDateTime, in: dateClosedRange, displayedComponents: [.hourAndMinute, .date]
                        ){
                            Text("Select a new arrival date")
                            
                        }
                        .onChange(of: arrivalDateTime) { newValue in
                            arrivalDateChanged = true
                        }
                    }
                }
                Section(header: Text("Flight Cost"), footer: Text("Press 'Enter' to Submit")) {
                    costSubview
                }
            }
            Group {
                Section(header: Text("Flight Purpose")) {
                    purposeSubview
                }
                
                Section(header: Text("Notes")) {
                    flightNotesSubview
                }
                if self.changeNotes {
                    Section(header: Text("New Flight Notes"), footer:
                                            Button(action: {
                                                self.dismissKeyboard()
                                            }) {
                                                Image(systemName: "keyboard")
                                                    .font(Font.title.weight(.light))
                                                    .foregroundColor(.blue)
                                            }
                                ) {
                                    TextEditor(text: $notes)
                                        .frame(height: 100)
                                        .font(.custom("Helvetica", size: 14))
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.leading)
                                        .autocapitalization(.none)
                                }
                }
                Section(header: Text("Boarding Pass")) {
                    flightPhotoSubview
                }
                if self.changeFlightPhoto {
                    Section(header: Text("New Boarding Pass")) {
                        VStack {
                            Picker("Take or Pick Photo", selection: $photoTakeOrPickIndex) {
                                ForEach(0 ..< photoTakeOrPickChoices.count, id: \.self) {
                                    Text(self.photoTakeOrPickChoices[$0])
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                           
                            Button(action: {
                                self.showImagePicker = true
                            }) {
                                Text("Get Photo")
                                    .padding()
                            }
                            Spacer()
                            
                            flightPhotoImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100.0, height: 100.0)
                        }   // End of VStack
                    }
                }   // End of If statement
                Section(header: Text("Airline Website")) {
                    websiteSubview
                }
            }
        }   // End of Form
        .font(.system(size: 14))
        .alert(isPresented: $showChangesSavedAlert, content: { self.changesSavedAlert })
        .disableAutocorrection(true)
        .autocapitalization(.words)
        .navigationBarTitle(Text("Change Flight"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                if self.changesMade() {
                    self.saveChanges()
                }
                // Show changes saved or no changes saved alert
                self.showChangesSavedAlert = true
            }) {
                Text("Save")
            })
        .sheet(isPresented: self.$showImagePicker) {
            PhotoCaptureView(showImagePicker: self.$showImagePicker,
                             photoImageData: self.$photoImageData,
                             cameraOrLibrary: self.photoTakeOrPickChoices[self.photoTakeOrPickIndex])
        }
       
    }   // End of body
    
    // Allows the user to dismiss their keyboard without needing to use the return key
    func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // Converts the departure date into a more user-friendly, readable format.
    var fullDepartureDate: String {
        let stringDate = flight.departureDateTime!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyy-MM-dd 'at' HH:mm:ss"
        let flightDate = dateFormatter.date(from: stringDate)
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.locale = Locale(identifier: "en_US")
        newDateFormatter.dateFormat = "E, MMM d, yyyy 'at' h:mm a"
        return newDateFormatter.string(from: flightDate!)
    }
    
    // Converts the arival date into a more user-friendly, readable format.
    var fullArrivalDate: String {
        let stringDate = flight.arrivalDateTime!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyy-MM-dd 'at' HH:mm:ss"
        let flightDate = dateFormatter.date(from: stringDate)
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.locale = Locale(identifier: "en_US")
        newDateFormatter.dateFormat = "E, MMM d, yyyy 'at' h:mm a"
        return newDateFormatter.string(from: flightDate!)
    }
   
    // View changes according to whether the user clicks on the edit pencil or not for Airline Name
    var airlineNameSubview: some View {
        return AnyView(
            VStack(alignment: .leading) {
                HStack {
                    Text(flight.airlineName ?? "")
                    Button(action: {
                        self.changeAirlineName.toggle()
                        self.airlineName = ""
                    }) {
                        if self.changeAirlineName {
                            Image(systemName: "xmark.circle")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "pencil.circle")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                    }
                }
                if self.changeAirlineName {
                    TextField("Change airline name", text: $airlineName)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        )
    }
    
    // Displays the trip cost in the correct format
    var flightCost: Text {
        let costOfFlight = flight.cost!.doubleValue

        // Add thousand separators to trip cost
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSize = 3

        let flightCostString = "$" + numberFormatter.string(from: costOfFlight as NSNumber)!
        return Text(flightCostString)
    }
    // View changes according to whether the user clicks on the edit pencil or not for Cost
    var costSubview: some View {
        return AnyView(
            VStack(alignment: .leading) {
                HStack {
                    flightCost
                    Button(action: {
                        self.changeCost.toggle()
                        self.cost = 0.0
                    }) {
                        if self.changeCost {
                            Image(systemName: "xmark.circle")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "pencil.circle")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                    }
                }
                if self.changeCost {
                    TextField("Change flight cost", value: $cost, formatter: flightCostFormatter)
                        .keyboardType(.numbersAndPunctuation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: cost) { newValue in
                            costChanged = true
                        }
                }
            }
        )
    }
    
    // View changes according to whether the user clicks on the edit pencil or not for Flight Purpose
    var purposeSubview: some View {
        return AnyView(
            VStack(alignment: .leading) {
                HStack {
                    Text(flight.purpose ?? "")
                    Button(action: {
                        self.changePurpose.toggle()
                        self.purpose = ""
                    }) {
                        if self.changePurpose {
                            Image(systemName: "xmark.circle")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "pencil.circle")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                    }
                }
                if self.changePurpose {
                    TextField("Change flight purpose", text: $purpose)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                }
            }
        )
    }
    // View changes according to whether the user clicks on the edit pencil or not for Flight Notes
    var flightNotesSubview: some View {
        return AnyView(
            VStack(alignment: .leading) {
                HStack {
                    Text(flight.notes ?? "")
                    Button(action: {
                        self.changeNotes.toggle()
                        self.notes = ""
                    }) {
                        if self.changeNotes {
                            Image(systemName: "xmark.circle")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "pencil.circle")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        )
    }
    
    // The new image the user has selected
    var flightPhotoImage: Image {
       
        if let imageData = self.photoImageData {
            let imageView = // This public function is given in UtilityFunctions.swift
                getImageFromBinaryData(binaryData: imageData, defaultFilename: "DefaultBoardingPass")
            return imageView
        } else {
            return Image("DefaultBoardingPass")
        }
    }
   
    // View changes according to whether the user clicks on the edit pencil or not for Flight Photo
    var flightPhotoSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    // This public function is given in UtilityFunctions.swift
                    getImageFromBinaryData(binaryData: flight.photo!.flightPhoto!, defaultFilename: "DefaultBoardingPass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0, height: 100.0)
                   
                    Button(action: {
                        self.changeFlightPhoto.toggle()
                        self.photoImageData = nil
                    }) {
                        if self.changeFlightPhoto {
                            Image(systemName: "xmark.circle")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "pencil.circle")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
            }   // End of VStack
        )
    }
   
    // View changes according to whether the user clicks on the edit pencil or not for Airline Website
    var websiteSubview: some View {
        return AnyView(
            VStack(alignment: .leading) {
                HStack {
                    Text(flight.airlineWebsite ?? "")
                    Button(action: {
                        self.changeAirlineWebsite.toggle()
                        self.airlineWebsite = ""
                    }) {
                        if self.changeAirlineWebsite {
                            Image(systemName: "xmark.circle")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                            
                        } else {
                            Image(systemName: "pencil.circle")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                    }
                }
                if self.changeAirlineWebsite {
                    TextField("Change airline website", text: $airlineWebsite)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
            }
        )
    }
  
    /*
     ---------------------
     MARK: - Alert Message
     ---------------------
     */
    var changesSavedAlert: Alert {
       
        if changesMade() {
            return Alert(title: Text("Changes Saved!"),
              message: Text("Your changes have been successfully saved to the database."),
              dismissButton: .default(Text("OK")) {
                  self.presentationMode.wrappedValue.dismiss()
                })
        }
 
        return Alert(title: Text("No Changes Saved!"),
          message: Text("You did not make any changes!"),
          dismissButton: .default(Text("OK")) {
              self.presentationMode.wrappedValue.dismiss()
            })
    }
  
    /*
     ---------------------------
     MARK: - Changes Made or Not
     ---------------------------
     */
    func changesMade() -> Bool {
       
        if self.airlineName.isEmpty && self.departureCode.isEmpty && self.arrivalCode.isEmpty && self.notes.isEmpty && self.purpose.isEmpty && self.airlineWebsite.isEmpty && self.photoImageData == nil && !costChanged && !departureDateChanged && !arrivalDateChanged {
            return false
        }
        return true
    }
   
    /*
     -------------------------
     MARK: - Save Flight Changes
     -------------------------
     */
    func saveChanges() {
        // Change Flight attributes if updated
       
        if self.airlineName != "" {
            flight.airlineName = self.airlineName
        }
        if self.departureCode != "" {
            flight.departureCode = self.departureCode
        }
        let newDepartureDate = dateAndTimeFormatter.string(from: self.departureDateTime)
        if departureDateChanged {
            flight.departureDateTime = newDepartureDate
        }
        if self.arrivalCode != "" {
            flight.arrivalCode = self.arrivalCode
        }
        let newArrivalDate = dateAndTimeFormatter.string(from: self.arrivalDateTime)
        if arrivalDateChanged {
            flight.arrivalDateTime = newArrivalDate
        }
        if costChanged {
            flight.cost = NSNumber(value: self.cost)
        }
        if self.purpose != "" {
            flight.purpose = self.purpose
        }
        if self.notes != "" {
            flight.notes = self.notes
        }
        if self.photoImageData != nil {
            if let imageData = self.photoImageData {
                flight.photo!.flightPhoto! = imageData
            } else {
                // Obtain the flight default image from Assets.xcassets as UIImage
                let photoUIImage = UIImage(named: "DefaultBoardingPass")
               
                // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
                let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
               
                // Assign photoData to Core Data entity attribute of type Data (Binary Data)
                flight.photo!.flightPhoto! = photoData!
            }
        }
        if self.airlineWebsite != "" {
            flight.airlineWebsite = self.airlineWebsite
        }
 
       
        /*
         ==================================
         Save Changes to Core Data Database
         ==================================
        */
       
        // ❎ CoreData Save operation
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
       
    }   // End of function
}
