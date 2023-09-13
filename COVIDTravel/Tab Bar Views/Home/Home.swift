//
//  Home.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/14/21.
//

import SwiftUI

// Implementation of Dashboard Charts with help from:
// https://github.com/AppPear/ChartView
// By Andras Samu

struct Home: View {
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
    @State private var nationView = false
    @State private var selectedStateChartIndex = 0
    let chartTypeState = ["New Cases", "New Deaths", "Positive Tests"]
    @State private var selectedNationwideChartIndex = 0
    let chartTypeNationwide = ["Cases", "Deaths"]
    @State private var showApiInfoAlert = false
    // Picker: Part 1 of 3
        let usStates = ["Alabama (AL)", "Alaska (AK)", "Arizona (AZ)", "Arkansas (AR)", "California (CA)", "Colorado (CO)", "Connecticut (CT)", "Delaware (DE)", "Florida (FL)", "Georgia (GA)", "Hawaii (HI)", "Idaho (ID)", "Illinois (IL)", "Indiana (IN)", "Iowa (IA)", "Kansas (KS)", "Kentucky (KY)", "Louisiana (LA)", "Maine (ME)", "Maryland (MD)", "Massachusetts (MA)", "Michigan (MI)", "Minnesota (MN)", "Mississippi (MS)", "Missouri (MO)", "Montana (MT)", "Nebraska (NE)", "Nevada (NV)", "New Hampshire (NH)", "New Jersey (NJ)", "New Mexico (NM)", "New York (NY)", "North Carolina (NC)", "North Dakota (ND)", "Ohio (OH)", "Oklahoma (OK)", "Oregon (OR)", "Pennsylvania (PA)", "Rhode Island (RI)", "South Carolina (SC)", "South Dakota (SD)", "Tennessee (TN)", "Texas (TX)", "Utah (UT)", "Vermont (VT)", "Virginia (VA)", "Washington (WA)", "West Virginia (WV)", "Wisconsin (WI)", "Wyoming (WY)"]
       
        // Picker: Part 2 of 3
    @State private var selectedIndex = 0
    var body: some View {
        ZStack {
            Color(red: 79/255, green: 132/255, blue: 227/255)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack (spacing: 15) {
                HStack(alignment: .center) {
                    Text("Dashboard")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(width: 250, height: 10, alignment: .leading)
                        .foregroundColor(.white)
                    if (!nationView) {
                        VStack(alignment: .trailing) {
                            Picker(selection: $selectedIndex, label: Text("Select State").font(.system(size: 13))) {
                                            ForEach(0..<usStates.count) {
                                                Text(self.usStates[$0])
                                            }
                                        }
                            .onChange(of: selectedIndex) { newValue in
                                getStateTimeseriesFromApi(stateAbbr: getStateAbbr(state: usStates[selectedIndex]))
                                userData.timeseriesList = stateTimeseriesList
                                userData.savedStateIndex = selectedIndex
                                userData.savedStateName = getStateAbbr(state: usStates[selectedIndex])
                                userData.setState = true
                                UserDefaults.standard.set(selectedIndex, forKey: "Index")
                                
                            }
                            .onAppear(perform: {
                                let index = UserDefaults.standard.integer(forKey:"Index")
                                selectedIndex = index
                            })
                            .foregroundColor(.white)
                            Text("\(getStateAbbr(state: usStates[selectedIndex]))")
                                    .font(.system(size: 17))
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .frame(width: 70, height: 10, alignment: .trailing)
                                    .foregroundColor(.white)
                        }
                        .pickerStyle(MenuPickerStyle())
                        Button(action: {
                            // Alert: Part 2 of 4
                            self.showApiInfoAlert = true
                        }) {
                            Image(systemName: "info.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.white)
                        }
                    // Alert: Part 3 of 4
                    .alert(isPresented: $showApiInfoAlert, content: { self.apiInfoAlert })
                    } else {
                        Text("USA")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .frame(width: 73, height: 34, alignment: .trailing)
                            .foregroundColor(.white)
                        Button(action: {
                            // Alert: Part 2 of 4
                            self.showApiInfoAlert = true
                        }) {
                            Image(systemName: "info.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.white)
                        }
                    // Alert: Part 3 of 4
                    .alert(isPresented: $showApiInfoAlert, content: { self.apiInfoAlert })
                    }
                }
                .padding(.top, 35)
                HStack {
                    Button(action: {
                        nationView = false
                    }) {
                        Text("State")
                            .foregroundColor(!nationView ? .black: .white)
                            .padding(.vertical, 12)
                            .frame(width: 150)
                    }
                    .background(!nationView ? Color.white: Color.clear)
                    .clipShape(Capsule())
                    
                    Button(action: {
                        nationView = true
                    }) {
                        Text("Nationwide")
                            .foregroundColor(nationView ? .black: .white)
                            .padding(.vertical, 12)
                            .frame(width: 150)
                    }
                    .background(nationView ? Color.white: Color.clear)
                    .clipShape(Capsule())
                }
                .background(Color.black.opacity(0.25))
                .clipShape(Capsule())
                .padding(.top, 10)
                .font(.system(size: 15))
                .padding(.bottom)
                if (!nationView) {
                    HStack(alignment: .center, spacing: 40) { // HStack 1
                        VStack {
                            Text("\(stateData.newCases)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                            Text("New Cases")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .onAppear(perform: {
                            let index = UserDefaults.standard.integer(forKey:"Index")
                            getStateDataFromApi(stateAbbr: getStateAbbr(state: usStates[index]))
                        })
                        .onChange(of: selectedIndex) { newValue in
                            getStateDataFromApi(stateAbbr: getStateAbbr(state: usStates[selectedIndex]))
                        }
                        
                        VStack {
                            Text(convertOverall(overall: stateData.overall))
                                .font(.title)
                                .foregroundColor(.red)
                                .fontWeight(.semibold)
                            Text("Risk Level")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .onAppear(perform: {
                            let index = UserDefaults.standard.integer(forKey:"Index")
                            getStateDataFromApi(stateAbbr: getStateAbbr(state: usStates[index]))
                        })
                        .onChange(of: selectedIndex) { newValue in
                            getStateDataFromApi(stateAbbr: getStateAbbr(state: usStates[selectedIndex]))
                        }
                        
                        VStack {
                            Text("\(stateData.newDeaths)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.purple)
                            Text("New Deaths")
                                .font(.caption)
                                .foregroundColor(.purple)
                        }
                        .onAppear(perform: {
                            let index = UserDefaults.standard.integer(forKey:"Index")
                            getStateDataFromApi(stateAbbr: getStateAbbr(state: usStates[index]))
                        })
                        .onChange(of: selectedIndex) { newValue in
                            getStateDataFromApi(stateAbbr: getStateAbbr(state: usStates[selectedIndex]))
                        }
                    } // End of HStack 1
                    .frame(width: UIScreen.main.bounds.size.width - 50, height: 65, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                } else {
                    HStack(alignment: .center, spacing: 15) { // HStack 1
                        VStack {
                            Text("\(nationwideData.todayCases)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                            Text("New Cases")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .padding(.vertical)
                        .frame(width: 150, height: 100)
                        .background(Color.white)
                        .cornerRadius(20)
                        VStack {
                            Text("\(nationwideData.todayDeaths)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.purple)
                            Text("New Deaths")
                                .font(.caption)
                                .foregroundColor(.purple)
                        }
                        .padding(.vertical)
                        .frame(width: 150, height: 100)
                        .background(Color.white)
                        .cornerRadius(20)
                    } // End of HStack 1
                } // End of top row configuration
                
                if (!nationView) {
                    HStack(spacing: 15) {
                        VStack {
                            Text("\(stateData.cases)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                            Text("Total Cases")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        .onAppear(perform: {
                            let index = UserDefaults.standard.integer(forKey:"Index")
                            getStateDataFromApi(stateAbbr: getStateAbbr(state: usStates[index]))
                        })
                        .onChange(of: selectedIndex) { newValue in
                            getStateDataFromApi(stateAbbr: getStateAbbr(state: usStates[selectedIndex]))
                        }
                        .padding(.vertical)
                        .frame(width: 150, height: 100)
                        .background(Color.white)
                        .cornerRadius(20)
                        VStack {
                            Text("\(stateData.deaths)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                            Text("Total Deaths")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        .onAppear(perform: {
                            let index = UserDefaults.standard.integer(forKey:"Index")
                            getStateDataFromApi(stateAbbr: getStateAbbr(state: usStates[index]))
                        })
                        .onChange(of: selectedIndex) { newValue in
                            getStateDataFromApi(stateAbbr: getStateAbbr(state: usStates[selectedIndex]))
                        }
                        .padding(.vertical)
                        .frame(width: 150, height: 100)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                } else {
                    HStack(spacing: 15) {
                        VStack {
                            Text("\(nationwideData.cases)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                            Text("Total Cases")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        .padding(.vertical)
                        .frame(width: 150, height: 100)
                        .background(Color.white)
                        .cornerRadius(20)
                        VStack {
                            Text("\(nationwideData.deaths)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                            Text("Total Deaths")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        .padding(.vertical)
                        .frame(width: 150, height: 100)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                } // End of second row configuration
                if (!nationView) {
                    Picker("", selection: $selectedStateChartIndex) {
                        ForEach(0 ..< chartTypeState.count, id: \.self) {
                            Text(self.chartTypeState[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color.white)
                    .cornerRadius(5)
                    .padding(.horizontal, 24)
                    
                    
                    VStack {
                        if (selectedStateChartIndex==0) {
                            BarChartView(data: ChartData(values: [("\(userData.timeseriesList[userData.timeseriesList.count - 8].date)",(userData.timeseriesList[userData.timeseriesList.count - 8].newCases)), ("\(userData.timeseriesList[userData.timeseriesList.count - 7].date)",(userData.timeseriesList[userData.timeseriesList.count - 7].newCases)), ("\(userData.timeseriesList[userData.timeseriesList.count - 6].date)",(userData.timeseriesList[userData.timeseriesList.count - 6].newCases)), ("\(userData.timeseriesList[userData.timeseriesList.count - 5].date)",(userData.timeseriesList[userData.timeseriesList.count - 5].newCases)), ("\(userData.timeseriesList[userData.timeseriesList.count - 4].date)",(userData.timeseriesList[userData.timeseriesList.count - 4].newCases)), ("\(userData.timeseriesList[userData.timeseriesList.count - 3].date)",(userData.timeseriesList[userData.timeseriesList.count - 3].newCases)), ("\(userData.timeseriesList[userData.timeseriesList.count - 2].date)",(userData.timeseriesList[userData.timeseriesList.count - 2].newCases))]), title: "\(chartTypeState[selectedStateChartIndex]) in the Last 7 Days", legend: "Quarterly", style: Styles.barChartStyleOrangeLight, form: ChartForm.extraLarge, dropShadow: false) // legend is optional
                        }
                        if (selectedStateChartIndex==1) {
                            BarChartView(data: ChartData(values: [("\(userData.timeseriesList[userData.timeseriesList.count - 8].date)",(userData.timeseriesList[userData.timeseriesList.count - 8].newDeaths)), ("\(userData.timeseriesList[userData.timeseriesList.count - 7].date)",(userData.timeseriesList[userData.timeseriesList.count - 7].newDeaths)), ("\(userData.timeseriesList[userData.timeseriesList.count - 6].date)",(userData.timeseriesList[userData.timeseriesList.count - 6].newDeaths)), ("\(userData.timeseriesList[userData.timeseriesList.count - 5].date)",(userData.timeseriesList[userData.timeseriesList.count - 5].newDeaths)), ("\(userData.timeseriesList[userData.timeseriesList.count - 4].date)",(userData.timeseriesList[userData.timeseriesList.count - 4].newDeaths)), ("\(userData.timeseriesList[userData.timeseriesList.count - 3].date)",(userData.timeseriesList[userData.timeseriesList.count - 3].newDeaths)), ("\(userData.timeseriesList[userData.timeseriesList.count - 2].date)",(userData.timeseriesList[userData.timeseriesList.count - 2].newDeaths))]), title: "\(chartTypeState[selectedStateChartIndex]) in the Last 7 Days", legend: "Quarterly", style: Styles.barChartStyleOrangeLight, form: ChartForm.extraLarge, dropShadow: false) // legend is optional
                        }
                        if (selectedStateChartIndex==2) {
                            LineChartView(data: [Double(userData.timeseriesList[userData.timeseriesList.count - 8].positiveTests),Double(userData.timeseriesList[userData.timeseriesList.count - 7].positiveTests),Double(userData.timeseriesList[userData.timeseriesList.count - 6].positiveTests),Double(userData.timeseriesList[userData.timeseriesList.count - 5].positiveTests),Double(userData.timeseriesList[userData.timeseriesList.count - 4].positiveTests),Double(userData.timeseriesList[userData.timeseriesList.count - 3].positiveTests),Double(userData.timeseriesList[userData.timeseriesList.count - 2].positiveTests)], title: "\(chartTypeState[selectedStateChartIndex]) in the Last 7 Days", form: ChartForm.extraLarge, rateValue: getPositiveRateValue(), dropShadow: false, valueSpecifier: "%.0f") // legend is optional, use optional .padding()
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(20)
                    Spacer()
                } else {
                    Picker("", selection: $selectedNationwideChartIndex) {
                        ForEach(0 ..< chartTypeNationwide.count, id: \.self) {
                            Text(self.chartTypeNationwide[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color.white)
                    .cornerRadius(5)
                    .padding(.horizontal, 24)
                    
                    
                    VStack {
                        if (selectedNationwideChartIndex==0) {
                            LineChartView(data: [Double(nationwideTimeseries.sevenCases),Double(nationwideTimeseries.sixCases),Double(nationwideTimeseries.fiveCases),Double(nationwideTimeseries.fourCases),Double(nationwideTimeseries.threeCases),Double(nationwideTimeseries.twoCases),Double(nationwideTimeseries.oneCases)], title: "\(chartTypeNationwide[selectedNationwideChartIndex]) in the Last 7 Days", form: ChartForm.extraLarge, rateValue: getCasesRateValue(), dropShadow: false, valueSpecifier: "%.0f") // legend is optional, use optional .padding()
                        }
                        if (selectedNationwideChartIndex==1) {
                            LineChartView(data: [Double(nationwideTimeseries.sevenDeaths),Double(nationwideTimeseries.sixDeaths),Double(nationwideTimeseries.fiveDeaths),Double(nationwideTimeseries.fourDeaths),Double(nationwideTimeseries.threeDeaths),Double(nationwideTimeseries.twoDeaths),Double(nationwideTimeseries.oneDeaths)], title: "\(chartTypeNationwide[selectedNationwideChartIndex]) in the Last 7 Days", form: ChartForm.extraLarge, rateValue: getDeathsRateValue(), dropShadow: false, valueSpecifier: "%.0f") // legend is optional, use optional .padding()
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(20)
                    Spacer()
                }
            } // End of VStack
        } // End of ZStack
    }
    
    // Alert to display API information
    var apiInfoAlert: Alert {
        Alert(title: Text("API Information"),
              message: Text("All State and Nationwide data is powered by the COVID-19 Act Now API (apidocs.covidactnow.org/api/) and the NovelCOVID API (disease.sh/docs/)."),
              dismissButton: .default(Text("OK")) )
    }
    
    // Retrieving state abbrevation
    func getStateAbbr(state: String) -> String {
        return String(state.dropLast().dropFirst(state.count - 3))
    }
    
    // Converts the numeric overall risk measurement to a user friendly ranking
    func convertOverall(overall: Int) -> String {
        var risk = ""
        if (overall == 0) {
            risk = "Low"
        }
        else if (overall == 1) {
            risk = "Medium"
        }
        else if (overall == 2) {
            risk = "High"
        }
        else if (overall == 3) {
            risk = "Very High"
        }
        else {
            risk = "Severe"
        }
        return risk
    }
    
    // Converts the number of cases into a rate
    func getCasesRateValue() -> String {
        // final-starting/starting * 100
        let rate = (Double(nationwideTimeseries.oneCases) - Double(nationwideTimeseries.sevenCases))*100/Double(nationwideTimeseries.sevenCases)
        let roundedRate = String(format: "%.2f", rate)
        return roundedRate
    }
    
    // Converts the number of deaths into a rate
    func getDeathsRateValue() -> String {
        // final-starting/starting * 100
        let rate = (Double(nationwideTimeseries.oneDeaths) - Double(nationwideTimeseries.sevenDeaths))*100/Double(nationwideTimeseries.sevenDeaths)
        let roundedRate = String(format: "%.2f", rate)
        return roundedRate
    }
    
    // Converts the number of recovered into a rate
    func getRecoveredRateValue() -> String {
        // final-starting/starting * 100
        if (Double(nationwideTimeseries.oneRecovered) - Double(nationwideTimeseries.sevenRecovered))*100 == 0 {
            return "-"
        }
        let rate = (Double(nationwideTimeseries.oneRecovered) - Double(nationwideTimeseries.sevenRecovered))*100/Double(nationwideTimeseries.sevenRecovered)
        let roundedRate = String(format: "%.2f", rate)
        return roundedRate
    }
    
    // Converts the number of positive tests into a rate
    func getPositiveRateValue() -> String {
        // final-starting/starting * 100
        if (Double(userData.timeseriesList[userData.timeseriesList.count - 2].positiveTests) - Double(userData.timeseriesList[userData.timeseriesList.count - 8].positiveTests))*100 == 0 {
            return "-"
        }
        let rate = (Double(userData.timeseriesList[userData.timeseriesList.count - 2].positiveTests) - Double(userData.timeseriesList[userData.timeseriesList.count - 8].positiveTests))*100/Double(userData.timeseriesList[userData.timeseriesList.count - 8].positiveTests)
        let roundedRate = String(format: "%.2f", rate)
        return roundedRate
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
