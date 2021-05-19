//
//  AudioPlayer.swift
//  NationalParks
//
//  Created by Mohsin on 4/14/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import Foundation
import Foundation
import SwiftUI
import Combine
import AVFoundation
 
final class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
   
    @Published var isPlaying = false
   
    var audioPlayer: AVAudioPlayer!
   
    /*
     ==============================================================================
     |   Create Audio Player to play an audio file with a given url of type URL   |
     ==============================================================================
     */
    // url = URL struct pointing to the audio file to be played
    func createAudioPlayer(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer!.prepareToPlay()
        } catch {
            print("Unable to create AVAudioPlayer!")
        }
    }
   
    /*
     ========================================================================
     |   Create Audio Player to play an audio file stored as of type Data   |
     ========================================================================
    
     /*
      audioData value is of type Data of the audio recording
      stored as Data or Binary Data in Core Data database.
      */
     func createAudioPlayer(audioData: Data) {
         do {
             audioPlayer = try AVAudioPlayer(data: audioData)
             audioPlayer!.prepareToPlay()
         } catch {
             print("Unable to create AVAudioPlayer!")
         }
     }
 
    */
   
    func startAudioPlayer() {
       
        let audioSession = AVAudioSession.sharedInstance()
       
        do {
            /*
             AVAudioSession.PortOverride.speaker option causes the system to route audio
             to the built-in speaker and microphone regardless of other settings.
             */
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Unable to route audio to the built-in speaker!")
        }
        /*
         Make this class to be a delegate for the AVAudioPlayerDelegate protocol so that
         we can implement the audioPlayerDidFinishPlaying protocol method below.
         */
        audioPlayer.delegate = self
       
        audioPlayer.play()
        isPlaying = true
    }
   
    func pauseAudioPlayer() {
        audioPlayer.pause()
        isPlaying = false
    }
   
    func stopAudioPlayer() {
        audioPlayer.stop()
        isPlaying = false
    }
   
    /*
     This AVAudioPlayerDelegate protocol method is implemented to set the
     @Published var isPlaying to false when the player finishes playing.
     */
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
   
}
 