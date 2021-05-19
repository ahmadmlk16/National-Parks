//
//  Audio.swift
//  NationalParks
//
//  Created by Mohsin on 4/14/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//


import Foundation
import CoreData
 
//Audio Model
public class Audio: NSManagedObject, Identifiable {
 
    @NSManaged public var id: UUID?
    @NSManaged public var voiceRecording: Data?
    @NSManaged public var park: Park?
}
 
