//
//  ParkDetails.swift
//  NationalParks
//
//  Created by Mohsin on 4/10/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import SwiftUI

import SwiftUI
import MapKit
 
struct ParkDetails: View {

    var Npark : NationalPark
    
    var body: some View {
        // A Form cannot have more than 10 Sections.
        // Group the Sections if more than 10.
        Form {
            Group {
                Section(header: Text("National Park Full Name")) {
                    Text(Npark.fullName)
                }
                Section(header: Text("States")) {
                    Text(Npark.states)
                }
                Section(header: Text("National Park Description")) {
                    Text(Npark.description)
                }
                Section(header: Text("National Park Service Webpage")) {
                    NavigationLink(destination: WebView(url: park.websiteUrl)) {
                        HStack{
                        Image(systemName: "globe")
                        Text("See National Park Service Webpage")
                        }
                    }
                }
                
                
                Section(header: Text("Show National Park Location On Map")) {
                    NavigationLink(destination: MapView(mapType: MKMapType.standard, latitude: Npark.latitude, longitude:Npark.longitude, delta: 800, deltaUnit: "meters", annotationTitle: Npark.fullName, annotationSubtitle: Npark.states)
                        .navigationBarTitle(Text(verbatim: Npark.fullName), displayMode: .inline)
                    .edgesIgnoringSafeArea(.all) ) {
                        Image(systemName: "map.fill")

                    }
                }
                
                Section(header: Text("National Park Photos")) {
                    ForEach(Npark.images) { aImage in

                                           getImageFromUrl(url: aImage.url)
                                           .resizable()
                                           .scaledToFit()
                        
                                                Text(aImage.caption)
                            .font(.footnote)
                            .multilineTextAlignment(.center)                                        }
                                  
                               }
            }
 
        }   // End of Form
        .navigationBarTitle(Text("National Park Details"), displayMode: .inline)

    }

   
}
 
 
struct ParkDetails_Previews: PreviewProvider {
    static var previews: some View {
        ParkDetails(Npark: park)
    }
}
