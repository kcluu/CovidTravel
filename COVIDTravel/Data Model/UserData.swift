//
//  UserData.swift
//  COVIDTravel
//
//  Created by Katelyn Luu on 4/16/21.
//

import Combine
import SwiftUI
 
final class UserData: ObservableObject {
    /*
     ---------------------------
     MARK: - Published Variables
     ---------------------------
     */
   
    // Publish timeseriesList with initial value of stateTimeseriesList obtained in StateTimeseriesApiData.swift
    @Published var timeseriesList = stateTimeseriesList
    // Publish savedStateIndex with initial value of 0
    @Published var savedStateIndex = 0
    // Publish savedStateIndex with initial value of ""// Publish savedStateIndex with initial value of 0
    @Published var savedStateName = ""
    // Publish if the user has set their state or not
    @Published var setState = false
    
    // Publish allSearchableStatisticsList with initial value of searchableStatisticsList obtained in StatisticApiData.swift
    @Published var allSearchableStatisticsList = searchableStatisticsList
    // Publish sortedList with initial value of sortedStatisticsFoundList obtained in StatisticApiData.swift
    @Published var sortedList = sortedStatisticsFoundList
    
    // Publish statesList with initial value of stateStructList obtained from StateRestrictionsApiData.swift
    @Published var statesList = stateStructList
    
    // ❎ Subscribe to notification that the managedObjectContext completed a save
    @Published var savedInDatabase =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

}
 
