//
//  LoadInitialContenData.swift
//  NationalParks
//
//  Created by Mohsin on 4/10/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import Foundation
 
// Global array of Album structs
var listOfParks = [JPark]()
 
/*
 *************************************
 MARK: - Load Initial Database Content
 *************************************
 */
public func loadInitialDatabaseContent() {
 
    listOfParks = loadFromMainBundle("InitialDatabaseContent.json")
}
 
/*
****************************************************
MARK: - Get JSON File from Main Bundle and Decode it
****************************************************
*/
func loadFromMainBundle<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
   
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Unable to find \(filename) in main bundle.")
    }
   
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Unable to load \(filename) from main bundle:\n\(error)")
    }
   
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Unable to parse \(filename) as \(T.self):\n\(error)")
    }
}

