//
//  Players.swift
//  NationalParks
//
//  Created by Mohsin on 4/12/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import Foundation
import AVFoundation
 
// Global Audio File Players
var audioPlayer: AVAudioPlayer?


public func createPlayer(name : String) {

    let file = name + ".m4a"
    
    let url = documentDirectory.appendingPathComponent(file)
    
    do {
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer!.prepareToPlay()
    } catch {
        print("Unable to create AVAudioPlayer!")
    }
   

}


