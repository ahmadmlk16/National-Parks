//
//  ParksVisited.swift
//  NationalParks
//
//  Created by Mohsin on 4/10/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import SwiftUI
import CoreData
 
struct ParksVisited: View {
   
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
   
    // ❎ CoreData FetchRequest returning all Park entities in the database
    @FetchRequest(fetchRequest: Park.allParksFetchRequest()) var allParks: FetchedResults<Park>
   
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Park entities with all the changes.
    @EnvironmentObject var userData: UserData
   
    var body: some View {
        NavigationView {
            if self.allParks.count == 0 {
               
                // If the database is empty, ask the user to populate it.
                Button(action: {
                    self.addInitialContentToDatabase()
                }) {
                    HStack {
                        Image(systemName: "gear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                        Text("Populate Database")
                    }
                }
            }
 
            List {
                /*
                 Each NSManagedObject has internally assigned unique ObjectIdentifier
                 used by ForEach to display the Parks in a dynamic scrollable list.
                 */
                ForEach(self.allParks) { aPark in
                    NavigationLink(destination: VisitedParkDetails(natPark: aPark)) {
                        ParkItem(park: aPark)
                    }
                }
                .onDelete(perform: delete)
               
            }   // End of List
            .navigationBarTitle(Text("National Parks Visited"), displayMode: .inline)
           
            // Place the Edit button on left and Add (+) button on right of the navigation bar
            .navigationBarItems(leading: EditButton(), trailing:
                NavigationLink(destination: ParkSurvey()) {
                    Image(systemName: "plus")
                })
           
        }   // End of NavigationView
    }
   
    /*
     ----------------------------
     MARK: - Delete Selected Park
     ----------------------------
     */
    func delete(at offsets: IndexSet) {
       
        let parkToDelete = self.allParks[offsets.first!]
       
        // ❎ CoreData Delete operation
        self.managedObjectContext.delete(parkToDelete)
 
        // ❎ CoreData Save operation
        do {
          try self.managedObjectContext.save()
        } catch {
          print("Unable to delete selected park!")
        }
    }
   
    /*
     ---------------------------------------
     MARK: - Add Initial Content to Database
     ---------------------------------------
     */
    func addInitialContentToDatabase() {
       
        // This public function is given in LoadInitialContentData.swift
        loadInitialDatabaseContent()
       
        // listOfMusicAlbums = [Album]() is now available
       
        for jpark in listOfParks {
            /*
             =====================================================
             Create an instance of the Park Entity and dress it up
             =====================================================
            */
            // ❎ Create an instance of the Park entity in CoreData managedObjectContext
            let aPark = Park(context: self.managedObjectContext)
           
            // ❎ Dress it up by specifying its attributes
            
            aPark.dateVisited = jpark.dateVisited
            aPark.fullName = jpark.fullName

            
            aPark.rating = jpark.rating
            aPark.speechToTextNotes = jpark.speechToTextNotes
            aPark.states = jpark.states

 
            let aPhoto = Photo(context: self.managedObjectContext)
            let aAudio = Audio(context: self.managedObjectContext)
                      
                       // Obtain the URL of the album cover photo filename from main bundle
//            let imageUrl = Bundle.main.url(forResource: jpark.photoAndAudioFilename, withExtension: "jpg", subdirectory: "NationalParkPhotos")
//
//                        do {
//                           // Try to get the photo image data from imageUrl
//                            aPhoto.nationalParkPhoto = try Data(contentsOf: imageUrl!, options: NSData.ReadingOptions.mappedIfSafe)
//
//                       } catch {
//                            fatalError("cover photo file is not found in the main bundle!")
//                       }

//                let audioUrl = Bundle.main.url(forResource: jpark.photoAndAudioFilename, withExtension: "m4a", subdirectory: "AudioFiles")
//                    do {
//                // Try to get the photo image data from imageUrl
//                        aAudio.voiceRecording = try Data(contentsOf: audioUrl!, options: NSData.ReadingOptions.mappedIfSafe)
//
//                    } catch {
//                        fatalError("Audio file is not found in the main bundle!")
//                    }
            
            
           
            aPhoto.dateTime = jpark.photoDateTime
            aPhoto.latitude = String(jpark.photoLatitude)
            aPhoto.longitude = String(jpark.photoLongitude)
            /*
             ==================================
             Save Changes to Core Data Database
             ==================================
            */
            aPark.photo = aPhoto
            aPark.audio = aAudio
            aPhoto.park = aPark
            aAudio.park = aPark
            
            // ❎ CoreData Save operation
            do {
                try self.managedObjectContext.save()
            } catch {
                return
            }
           
        }   // End of for loop
    }
 
}
 
struct ParksVisited_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 
 
