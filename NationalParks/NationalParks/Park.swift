//
//  Park.swift
//  NationalParks
//
//  Created by Mohsin on 4/10/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//


import Foundation
import CoreData

/*
 🔴 Set Current Product Module:
 In xcdatamodeld editor, select Park, show Data Model Inspector, and
 select Current Product Module from Module menu.
 🔴 Turn off Auto Code Generation:
 In xcdatamodeld editor, select Park, show Data Model Inspector, and
 select Manual/None from Codegen menu.
 */

// ❎ CoreData Park entity public class
public class Park: NSManagedObject, Identifiable {
    

    @NSManaged public var fullName: String?
    @NSManaged public var states: String?
    @NSManaged public var dateVisited: String?
    @NSManaged public var speechToTextNotes: String?
    @NSManaged public var rating: String?
    @NSManaged public var photo: Photo?
    @NSManaged public var audio: Audio?

    
}

extension Park {
    /*
     ❎ CoreData FetchRequest in ContentView calls this function
     to get all of the Park entities in the database
     */
    static func allParksFetchRequest() -> NSFetchRequest<Park> {
        
        let request: NSFetchRequest<Park> = Park.fetchRequest() as! NSFetchRequest<Park>
        /*
         List the Parks in alphabetical order with respect to artistName;
         If artistName is the same, then sort with respect to ParkName.
         */
        request.sortDescriptors = [
            // Primary sort key: artistName
            NSSortDescriptor(key: "fullName", ascending: true),
        ]
        
        return request
    }
}
