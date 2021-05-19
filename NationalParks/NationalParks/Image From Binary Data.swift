//
//  Image From Binary Data.swift
//  NationalParks
//
//  Created by Mohsin on 4/14/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import Foundation
import SwiftUI
 
/*
*************************************************
|   Return Photo Image from Given Binary Data   |
*************************************************
*/
public func photoImageFromBinaryData(binaryData: Data?) -> Image {
 
    // Create a UIImage object from binaryData
    if binaryData == nil{
        return Image("DefaultParkPhoto")
    }
    let uiImage = UIImage(data: binaryData!)
  
    // Unwrap uiImage to see if it has a value
    if let imageObtained = uiImage {
      
        // Image is successfully obtained
        return Image(uiImage: imageObtained)
      
    } else {
        return Image("DefaultParkPhoto")
    }
  
}
 
