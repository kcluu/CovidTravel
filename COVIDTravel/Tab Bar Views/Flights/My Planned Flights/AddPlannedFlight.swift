//
//  AddPlannedFlight.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/29/21.
//

import SwiftUI
import CoreData
 
struct AddPlannedFlight: View {
   
    // Enable this View to be dismissed to go back when the Save button is tapped
    @Environment(\.presentationMode) var presentationMode
   
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
   
    @State private var showFlightAddedAlert = false
    @State private var showInputDataMissingAlert = false
   
    // Flight Entity
    @State private var airlineName = ""
    @State private var departureCode = ""
    @State private var departureDateTime = Date()
    @State private var cost = 0.0
    @State private var arrivalCode = ""
    @State private var arrivalDateTime = Date()
    @State private var notes = ""
    @State private var purpose = ""
    @State private var airlineWebsite = ""
   
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
                    HStack {
                        TextField("Enter airline name", text: $airlineName)
                            .disableAutocorrection(true)
                            .autocapitalization(.words)
                        // Button to clear the text field
                        Button(action: {
                            self.airlineName = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Departure Details")) {
                    VStack(alignment: .leading) {
                        HStack {
                            TextField("Enter airport departure code", text: $departureCode)
                                .disableAutocorrection(true)
                                .autocapitalization(.allCharacters)
                                .disabled(departureCode.count > 2)
                            // Button to clear the text field
                            Button(action: {
                                self.departureCode = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                        Spacer()
                        DatePicker(selection: $departureDateTime, in: dateClosedRange, displayedComponents: [.hourAndMinute, .date]
                        ){
                            Text("Select a departure date")
                            
                        }
                    }
                }
                Section(header: Text("Arrival Details")) {
                    VStack(alignment: .leading) {
                        HStack {
                            TextField("Enter airport arrival code", text: $arrivalCode)
                                .disableAutocorrection(true)
                                .autocapitalization(.allCharacters)
                                .disabled(arrivalCode.count > 2)
                            // Button to clear the text field
                            Button(action: {
                                self.arrivalCode = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                        Spacer()
                        DatePicker(selection: $arrivalDateTime, in: dateClosedRange, displayedComponents: [.hourAndMinute, .date]
                        ){
                            Text("Select an arrival date")
                            
                        }
                    }
                }
                Section(header: Text("Flight Cost"), footer: Text("Press 'Enter' to Submit")) {
                    HStack {
                        TextField("Enter flight cost", value: $cost, formatter: flightCostFormatter)
                            .keyboardType(.numbersAndPunctuation)
                    }
                }
            }   // End of Group
            Group {
                Section(header: Text("Flight Purpose")) {
                    HStack {
                        TextField("Enter flight purpose", text: $purpose)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        // Button to clear the text field
                        Button(action: {
                            self.purpose = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Notes"), footer:
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
            .alert(isPresented: $showFlightAddedAlert, content: { self.flightAddedAlert })
            Group {
                Section(header: Text("Add Boarding Pass")) {
                    VStack {
                        photoImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100.0, height: 100.0)
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
                    }   // End of VStack
                }
                Section(header: Text("Airline Website")) {
                    HStack {
                        TextField("Enter airline website URL", text: $airlineWebsite)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        // Button to clear the text field
                        Button(action: {
                            self.airlineWebsite = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
            }   // End of Group
 
        }   // End of Form
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .autocapitalization(.words)
        .disableAutocorrection(true)
        .font(.system(size: 14))
        .alert(isPresented: $showInputDataMissingAlert, content: { self.inputDataMissingAlert })
        .navigationBarTitle(Text("Add Flight"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                if self.inputDataValidated() {
                    self.saveNewFlight()
                    self.showFlightAddedAlert = true
                } else {
                    self.showInputDataMissingAlert = true
                }
            }) {
                Text("Save")
            })
       
        .sheet(isPresented: self.$showImagePicker) {
            /*
             🔴 We pass $showImagePicker and $photoImageData with $ sign into PhotoCaptureView
             so that PhotoCaptureView can change them. The @Binding keywork in PhotoCaptureView
             indicates that the input parameter is passed by reference and is changeable (mutable).
             */
            PhotoCaptureView(showImagePicker: self.$showImagePicker,
                             photoImageData: self.$photoImageData,
                             cameraOrLibrary: self.photoTakeOrPickChoices[self.photoTakeOrPickIndex])
        }
       
    }   // End of body
    // Allows the user to dismiss their keyboard without needing to use the return key
    func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
   
    var photoImage: Image {
       
        if let imageData = self.photoImageData {
            // The public function is given in UtilityFunctions.swift
            let imageView = getImageFromBinaryData(binaryData: imageData, defaultFilename: "DefaultBoardingPass")
            return imageView
        } else {
            return Image("DefaultBoardingPass")
        }
    }
   
    /*
     ------------------------
     MARK: - Flight Added Alert
     ------------------------
     */
    var flightAddedAlert: Alert {
        Alert(title: Text("Flight Added!"),
              message: Text("New flight is added to your Planned Flights list."),
              dismissButton: .default(Text("OK")) {
                // Dismiss this View and go back
                self.presentationMode.wrappedValue.dismiss()
          })
    }
   
    /*
     --------------------------------
     MARK: - Input Data Missing Alert
     --------------------------------
     */
    var inputDataMissingAlert: Alert {
        Alert(title: Text("Missing Input Data!"),
              message: Text("Required Data: airline name, departure details, and arrival details"),
              dismissButton: .default(Text("OK")) {
                // Dismiss this View and go back
                self.presentationMode.wrappedValue.dismiss()
          })
    }
   
    /*
     -----------------------------
     MARK: - Input Data Validation
     -----------------------------
     */
    func inputDataValidated() -> Bool {
 
        if self.airlineName.isEmpty || self.departureCode.isEmpty || self.arrivalCode.isEmpty {
            return false
        }
       
        return true
    }
   
    /*
     ---------------------
     MARK: - Save New Flight
     ---------------------
     */
    func saveNewFlight() {
       
        /*
         =====================================================
         Create an instance of the Flight Entity and dress it up
         =====================================================
        */
       
        // ❎ Create a new Flight entity in CoreData managedObjectContext
        let newFlight = Flight(context: self.managedObjectContext)
       
        // ❎ Dress up the new Flight entity
        newFlight.airlineName = self.airlineName
        
        newFlight.departureCode = self.departureCode
        let newDepartureDate = dateAndTimeFormatter.string(from: self.departureDateTime)
        newFlight.departureDateTime = newDepartureDate
        
        newFlight.arrivalCode = self.arrivalCode
        let newArrivalDate = dateAndTimeFormatter.string(from: self.arrivalDateTime)
        newFlight.arrivalDateTime = newArrivalDate
        
        newFlight.cost = NSNumber(value: self.cost)
        newFlight.purpose = self.purpose
        newFlight.notes = self.notes
        newFlight.airlineWebsite = self.airlineWebsite
       
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
        */
       
        // ❎ Create a new Photo entity in CoreData managedObjectContext
        let newPhoto = Photo(context: self.managedObjectContext)
       
        // ❎ Dress up the new Photo entity
        if let imageData = self.photoImageData {
            newPhoto.flightPhoto = imageData
        } else {
            // Obtain the flight default image from Assets.xcassets as UIImage
            let photoUIImage = UIImage(named: "DefaultBoardingPass")
           
            // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
            let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
           
            // Assign photoData to Core Data entity attribute of type Data (Binary Data)
            newPhoto.flightPhoto = photoData!
        }
       
        /*
         ==============================
         Establish Entity Relationships
         ==============================
        */
       
        // Establish One-to-One Relationship between Flight and Photo
        newFlight.photo = newPhoto
        newPhoto.flight = newFlight
       
        /*
         =============================================
         MARK: - ❎ Save Changes to Core Data Database
         =============================================
         */
       
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
       
    }   // End of function
 
}
