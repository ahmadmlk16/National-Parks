//
//  JPark.swift
//  NationalParks
//
//  Created by Mohsin on 4/10/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

//Park Struct to save json data
struct JPark: Codable {
    
    var photoAndAudioFilename: String
    var fullName: String
    var states: String
    var dateVisited: String
    var photoDateTime: String
    var photoLatitude: Double
    var photoLongitude: Double
    var speechToTextNotes: String
    var rating: String
    
}
