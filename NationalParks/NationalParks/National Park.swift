//
//  National Park.swift
//  NationalParks
//
//  Created by Mohsin on 4/10/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import Foundation
 
import Foundation
 

//National Park Struct
struct NationalPark: Hashable, Identifiable {
    
    var id: UUID
    var fullName: String
    var states: String
    var websiteUrl: String
    var latitude: Double
    var longitude: Double
    var description: String
    var images: [ParkPhoto]
}
 
//Park Phot Object
struct ParkPhoto: Hashable, Identifiable {
 
    var id: UUID
    var url: String
    var caption: String
}
