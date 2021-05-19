//
//  VisitedParkDetails.swift
//  NationalParks
//
//  Created by Mohsin on 4/10/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import SwiftUI

import SwiftUI
import MapKit





struct VisitedParkDetails: View {
    
    var natPark: Park
    @EnvironmentObject var audioPlayer: AudioPlayer
    @Environment(\.presentationMode) var presentationMode
    @State var playPauseIcon = "play.fill"
    var body: some View {
        
        // A Form cannot have more than 10 Sections.
        // Group the Sections if more than 10.
        Form {
                Section(header: Text("National Park Full Name")) {
                    Text(natPark.fullName ?? "")
                }
                Section(header: Text("States")) {
                    Text(natPark.states ?? "")
                }
                
                Section(header: Text("National Park Visit Photo")) {
                    photoImageFromBinaryData(binaryData: natPark.photo?.nationalParkPhoto)
                    .resizable()
                    .scaledToFit()
                }
                
                
                Section(header: Text("Show National Park Location On Map")) {
                    NavigationLink(destination: map
                        .navigationBarTitle(Text (natPark.fullName ?? ""), displayMode: .inline)
                    .edgesIgnoringSafeArea(.all) ) {
                        Image(systemName: "map.fill")

                    }
                }
            
                Section(header: Text("Play Voice Memo")) {
                    Button(action: {
                        self.createPlayer()
                        if self.audioPlayer.isPlaying {
                            self.audioPlayer.pauseAudioPlayer()
                            self.playPauseIcon = "play.fill"
                        } else {
                            self.audioPlayer.startAudioPlayer()
                            self.playPauseIcon = "pause.fill"                        }
                    }) {
                        Image(systemName: playPauseIcon)
                            .foregroundColor(.blue)
                            .font(Font.title.weight(.regular))
                        }
                }
                
                
                Section(header: Text("Notes Taken by Speech to Text Conversation")) {
                    Text(natPark.speechToTextNotes ?? "" )
                }
                
                
                
                Section(header: Text("Date Visited National Park")) {
                    Text(date(date: natPark.dateVisited ?? ""))
                }
                
                Section(header: Text("My National Park Rating")) {
                    Text(natPark.rating ?? "" )
                }
            
        }   // End of Form
            .navigationBarTitle(Text("National Park Details"), displayMode: .inline)
            
    }
    
    
    var map: some View {
        
        let lat = natPark.photo?.latitude ?? "0.0"
        let long = natPark.photo?.longitude ?? "0.0"
        
        let Lat = Double(lat)
        let Long = Double(long)
        
        return MapView(mapType: MKMapType.standard, latitude: Lat!, longitude:Long!, delta: 800, deltaUnit: "meters", annotationTitle:natPark.fullName ?? " ", annotationSubtitle: natPark.states ?? " ")
    
    }
    
    func createPlayer() {
       
        let filename = natPark.audio?.id?.uuidString ?? "" + ".m4a"
        let voiceMemoFileUrl = documentDirectory.appendingPathComponent(filename)
       
        audioPlayer.createAudioPlayer(url: voiceMemoFileUrl)
    }
    
}


struct VisitedParkDetails_Previews: PreviewProvider {
    static var previews: some View {
        ParkDetails(Npark: park)
    }
}
