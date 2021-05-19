//
//  Date Converter.swift
//  NationalParks
//
//  Created by Mohsin on 4/12/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import Foundation


public func date(date: String) -> String {
    
    let stringDate = date

    
    let dateFormatter = DateFormatter()
     
    // Set the date format to yyyy-MM-dd
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "en_US")
     
    // Convert date String from "yyyy-MM-dd" to Date struct
    let dateStruct = dateFormatter.date(from: stringDate)
     
    // Create a new instance of DateFormatter
    let newDateFormatter = DateFormatter()
     
    newDateFormatter.locale = Locale(identifier: "en_US")
    newDateFormatter.dateStyle = .medium // Thursday, November 7, 2019
    newDateFormatter.timeStyle = .none
     
    // Obtain newly formatted Date String as "Thursday, November 7, 2019"
    let dateWithNewFormat = newDateFormatter.string(from: dateStruct!)

    
    return dateWithNewFormat}
