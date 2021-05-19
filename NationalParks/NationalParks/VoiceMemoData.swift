//
//  VoiceMemoData.swift
//  NationalParks
//
//  Created by Mohsin on 4/12/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

//
//  VoiceMemoData.swift
//  Communicate
//
//  Created by Osman Balci on 3/9/20.
//  Copyright © 2020 Osman Balci. All rights reserved.
//
 
import Foundation
import SwiftUI
import AVFoundation
 
/*
 Create an empty mutable array of VoiceMemo structs using initializer () and
 store its object reference into the global variable voiceMemoStructList.
 */

 
// Set document directory URL as a global constant. It is used in
// this file, RecordVoiceMemo.swift, and VoiceMemoDetail.swift
let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
 
// Global Variables
var audioSession:   AVAudioSession!
var audioRecorder:  AVAudioRecorder!
 
/*
******************************************
MARK: - Get Permission for Voice Recording
******************************************
*/
public func getPermissionForVoiceRecording() {
   
    // Create the shared audio session instance
    audioSession = AVAudioSession.sharedInstance()
   
    do {
        // Set audio session category to record and play back audio
        try audioSession.setCategory(.playAndRecord, mode: .default)
       
        // Activate the audio session
        try audioSession.setActive(true)
       
        // Request permission to record user's voice
        audioSession.requestRecordPermission() { allowed in
            DispatchQueue.main.async {
                if allowed {
                    // Permission is recorded in the Settings app on user's device
                } else {
                    // Permission is recorded in the Settings app on user's device
                }
            }
        }
    } catch {
        print("Setting category or getting permission failed!")
    }
}
 

 
