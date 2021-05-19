//
//  Photo.swift
//  NationalParks
//
//  Created by Mohsin on 4/14/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//


import Foundation
import CoreData
 
//Photo Model
public class Photo: NSManagedObject, Identifiable {
 
    @NSManaged public var dateTime: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var nationalParkPhoto: Data?
    @NSManaged public var park: Park?
}
 
