//
//  ParkItem.swift
//  NationalParks
//
//  Created by Mohsin on 4/10/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import SwiftUI

import SwiftUI
 
struct ParkItem: View {
    // ❎ Input parameter: CoreData Park Entity instance reference
    let park: Park
   
    // ❎ CoreData FetchRequest returning all Park entities in the database
    @FetchRequest(fetchRequest: Park.allParksFetchRequest()) var allParks: FetchedResults<Park>
   
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Park entities with all the changes.
    @EnvironmentObject var userData: UserData
   
    var body: some View {
        HStack {
            photoImageFromBinaryData(binaryData: park.photo?.nationalParkPhoto)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0, height: 80.0)
           
            VStack(alignment: .leading) {
                /*
                ?? is called nil coalescing operator.
                IF Park.artistName is not nil THEN
                    unwrap it and return its value
                ELSE return ""
                */
                Text(park.fullName ?? "")
                Text(date(date: park.dateVisited ?? ""))
                Text(park.rating ?? "")
            }
            .font(.callout)
        }
    }
    

}
 
 
