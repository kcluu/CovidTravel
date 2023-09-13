//
//  StatisticsList.swift
//  CovidTravel
//
//  Created by James Kim on 4/14/21.
//

import SwiftUI

struct StatisticsList: View {
    
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
    
    @State private var searchItem = ""
    
    var body: some View {
        NavigationView {
            
            VStack {
                Divider()
                Text("Risk Level Legend: ")
                HStack {
                    VStack {
                        Image("low")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30.0)
                        Text("Low")
                            .font(.system(size: 13))
                    }
                    
                    VStack {
                        Image("medium")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30.0)
                        Text("Medium")
                            .font(.system(size: 13))
                    }
                    
                    VStack {
                        Image("high")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30.0)
                        Text("High")
                            .font(.system(size: 13))
                    }
                    
                    VStack {
                        Image("veryhigh")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30.0)
                        Text("Very High")
                            .font(.system(size: 13))
                    }
                    
                    VStack {
                        Image("severe")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30.0)
                        Text("Severe")
                            .font(.system(size: 13))
                    }
                    
                    
                    
                }
                
                List {
                    SearchBar(searchItem: $searchItem, placeholder: "Search State")
                    
                    ForEach(userData.allSearchableStatisticsList.filter {self.searchItem.isEmpty ? true : $0.localizedStandardContains(self.searchItem)}, id: \.self)
                    { item in
                        NavigationLink(destination: StatisticDetails(stat: self.searchItemStatistic(searchListItem: item)))
                        {
                            StatisticItem(stat: self.searchItemStatistic(searchListItem: item))
                        }
                    }
                    
                    
                }   // End of List
                
            }
            .navigationBarTitle(Text("Covid-19 State Statistics"), displayMode: .inline)
            
        }   // End of NavigationView
        .customNavigationViewStyle()  // Given in NavigationStyle.swift
    }
    
    func searchItemStatistic(searchListItem: String) -> Statistic {
        
        // Find the index number of sortedList matching the country attribute 'id'
        let index = userData.sortedList.firstIndex(where: {$0.id.uuidString == searchListItem.components(separatedBy: "|")[0]})!
        
        return userData.sortedList[index]
    }
    
    
}

struct Statistics_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsList().environmentObject(UserData())
    }
}

