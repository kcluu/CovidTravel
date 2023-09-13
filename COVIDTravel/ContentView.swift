//
//  ContentView.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/14/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            StatisticsList()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Statistics")
                }
            Restrictions()
                .tabItem {
                    Image(systemName: "square.grid.3x3.fill")
                    Text("Restrictions")
                }
            Flights(filename: "SearchAirports")
                .tabItem {
                    Image(systemName: "airplane")
                    Text("Flights")
                }
            FindVaccines()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Vaccines")
                }
        }
        .font(.headline)
        .imageScale(.medium)
        .font(Font.title.weight(.regular))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
