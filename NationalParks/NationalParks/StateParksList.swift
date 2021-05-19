//
//  StateParksList.swift
//  NationalParks
//
//  Created by Mohsin on 4/12/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import SwiftUI

import SwiftUI
 
struct StateParksList: View {
   
    let Npark: String

    var body: some View {
        List {
            // Each Park struct in foundParksList has its own unique ID used by ForEach
            ForEach(foundParksList) { aPark in
                NavigationLink(destination: ParkDetails(Npark: aPark)) {
                    //SearchResultItem(Park: aPark)
                    StateParkItem(Npark: aPark)
                }
            }
        }
        .navigationBarTitle(Text("National Parks in \(Npark)"), displayMode: .inline)
    }
}
 
 
struct StateParksList_Previews: PreviewProvider {
    static var previews: some View {
        StateParksList(Npark: park.fullName)
    }
}
 
