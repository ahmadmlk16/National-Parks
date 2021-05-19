//
//  ParkSurvey.swift
//  NationalParks
//
//  Created by Mohsin on 4/12/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import SwiftUI
import CoreData
import AVFoundation

struct ParkSurvey: View {
   
    // Enable this View to be dismissed to go back when the Save button is tapped
    @Environment(\.presentationMode) var presentationMode
   
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
   
    fileprivate var idAndFilename = UUID()
    @State private var recordingVoice = false
     @State private var recordingVoice2 = false
    @State private var speechConvertedToText = ""
  
    
    
    // Song Entity
    @State private var parkName = ""
    @State private var stateNames = ""
    @State private var dateVisited = Date()
    @State private var rating = ""
    @State private var releaseDate = Date()
    @State private var ratingIndex = 2  // Default: "Average"
   
    // Album Cover Photo
    @State private var showImagePicker = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 0     // Take using camera
   
    let ratingChoices = ["Excellent", "Good", "Average", "Fair", "Poor"]
    var photoTakeOrPickChoices = ["Camera", "Photo Library"]
   
    var dateClosedRange: ClosedRange<Date> {
        // Set minimum date to 20 years earlier than the current year
        let minDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
       
        // Set maximum date to 2 years later than the current year
        let maxDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())!
        return minDate...maxDate
    }
   
    var body: some View {
        Form {
            Section(header: Text("National Park Full Name")) {
                TextField("Enter artist name", text: $parkName)
            }
            Section(header: Text("National Park State Names")) {
                TextField("Enter album name", text: $stateNames)
            }
            
            Section(header: Text("Date Visited National park")) {
                DatePicker(
                    selection: $dateVisited,
                    in: dateClosedRange,
                    displayedComponents: .date,
                    label: { Text("Date Visited") }
                )
            }
            Section(header: Text("My Rating")) {
                Picker("", selection: $ratingIndex) {
                    ForEach(0 ..< ratingChoices.count, id: \.self) {
                        Text(self.ratingChoices[$0])
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            
            Section(header: Text("Voice Recording")) {
                           Button(action: {
                               self.microphoneTapped()
                           }) {
                               microphoneLabel
                           }
                         
                           /*
                            ----------------------------------------------------------------------------
                            Modifying the same view with more than one .alert does not work!
                            You should modify a different view for each .alert to work. Therefore,
                            savedAlert is attached to the Button and errorAlert is attached to the Form.
                            ----------------------------------------------------------------------------
                            */
                       }
            
            Section(header: Text("Convert To Speech")) {
                VStack {
                    Button(action: {
                        self.microphoneTapped2()
                    }) {
                        microphoneLabel2
                    }
                    .padding()
                    Text(speechConvertedToText)
                        .multilineTextAlignment(.center)
                        // This enables the text to wrap around on multiple lines
                        .fixedSize(horizontal: false, vertical: true)
                }
                .onDisappear() {
                    self.speechConvertedToText = ""
                }
            }
            
            
            
            
            
            Section(header: Text("Add National Park Visit Photo")) {
                VStack {
                    Picker("Take or Pick Photo", selection: $photoTakeOrPickIndex) {
                        ForEach(0 ..< photoTakeOrPickChoices.count, id: \.self) {
                            Text(self.photoTakeOrPickChoices[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Button(action: {
                        self.showImagePicker = true
                    }) {
                        Text("Get Photo")
                            .padding()
                    }
                }   // End of VStack
            }
            Section(header: Text("National Park Visit Photo")) {
                thumbnailImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100.0, height: 100.0)
                Spacer()
            }
 
        }   // End of Form
        .disableAutocorrection(true)
        .autocapitalization(.words)
        .navigationBarTitle(Text("Add New National Park Visit"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                self.saveNewSong()
               
                // Dismiss this View and go back
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
            })
        
        .sheet(isPresented: self.$showImagePicker) {
            /*
             🔴 We pass $showImagePicker and $photoImageData with $ sign into PhotoCaptureView
             so that PhotoCaptureView can change them. The @Binding keywork in PhotoCaptureView
             indicates that the input parameter passed is changeable (mutable).
             */
            PhotoCaptureView(showImagePicker: self.$showImagePicker,
                             photoImageData: self.$photoImageData,
                             cameraOrLibrary: self.photoTakeOrPickChoices[self.photoTakeOrPickIndex])
        }
       
    }   // End of body
   
    var thumbnailImage: Image {
       
        if let imageData = self.photoImageData {
            let thumbnail = photoImageFromBinaryData(binaryData: imageData)
            return thumbnail
        } else {
            return Image("DefaultParkPhoto")
        }
    }
    
    
    var microphoneLabel: some View {
        VStack {
            Image(systemName: recordingVoice ? "mic.fill" : "mic.slash.fill")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.blue)
                .padding()
            Text(recordingVoice ? "Recording your voice... Tap to Stop!" : "Start Recording!")
                .multilineTextAlignment(.center)
        }
    }
    
    var microphoneLabel2: some View {
        VStack {
            Image(systemName: recordingVoice2 ? "mic.fill" : "mic.slash.fill")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.blue)
            Text(recordingVoice2 ? "Recording your voice... Tap to Stop!" : "Convert Speech to Text!")
                .padding()
                .multilineTextAlignment(.center)
        }
    }
   
    /*
     ---------------------
     MARK: - Save New Song
     ---------------------
     */
    func saveNewSong() {

        // Input Data Validation
        if self.parkName.isEmpty || self.stateNames.isEmpty {
            return
        }

        // Instantiate a DateFormatter object
        let dateFormatter = DateFormatter()

        // Set the date format to yyyy-MM-dd
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // Obtain DatePicker's selected date, format it as yyyy-MM-dd, and convert it to String
        let visitDateString = dateFormatter.string(from: self.dateVisited)

        /*
         =====================================================
         Create an instance of the Song Entity and dress it up
         =====================================================
        */

        // ❎ Create a new Song entity in CoreData managedObjectContext
        let newPark = Park(context: self.managedObjectContext)

        // ❎ Dress up the new Song entity
        
        newPark.fullName = self.parkName
        newPark.states = self.stateNames
        newPark.dateVisited = visitDateString
        newPark.rating = self.ratingChoices[ratingIndex]
        if(self.speechConvertedToText.isEmpty){
            newPark.speechToTextNotes = "No Text Recorded"
        }else{
        newPark.speechToTextNotes = self.speechConvertedToText
    
        }
        
        /*
         ==========================================================
         Create an instance of the Thumbnail Entity and dress it up
         ==========================================================
        */

        // ❎ Create a new Thumbnail entity in CoreData managedObjectContext
        let newPhoto = Photo(context: self.managedObjectContext)

        // ❎ Dress up the new Thumbnail entity
        if let imageData = self.photoImageData {
            newPhoto.nationalParkPhoto = imageData
        } else {
            // Obtain the URL of the AlbumCoverDefaultImage.png file from main bundle
            let defaultImageUrl = Bundle.main.url(forResource: "AlbumCoverDefaultImage", withExtension: "jpg", subdirectory: "NationalParkPhotos")

            do {
               // Try to get the image data from defaultImageUrl
                newPhoto.nationalParkPhoto = try Data(contentsOf: defaultImageUrl!, options: NSData.ReadingOptions.mappedIfSafe)

           } catch {
                fatalError("AlbumCoverDefaultImage.png file is not found in the main bundle!")
           }
        }

        let dateAndTime = Date()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let taskDateTime = dateFormatter2.string(from: dateAndTime)
        newPhoto.dateTime = taskDateTime
        
        
        let currLocation = currentLocation()

        newPhoto.latitude = String(currLocation.latitude)
        newPhoto.longitude = String(currLocation.longitude)

        
        
        
        let newAudio = Audio(context: self.managedObjectContext)

       
            // Obtain the URL of the AlbumCoverDefaultImage.png file from main bundle
        let audioFileName = idAndFilename.uuidString + ".m4a"
        let audioFilenameUrl = documentDirectory.appendingPathComponent(audioFileName)
        let defaultAudioUrl = audioFilenameUrl

            do {
               // Try to get the image data from defaultImageUrl
                newAudio.voiceRecording = try Data(contentsOf: defaultAudioUrl, options: NSData.ReadingOptions.mappedIfSafe)

           } catch {
                fatalError("AlbumCoverDefaultImage.png file is not found in the main bundle!")
           }
        
        newAudio.id = idAndFilename
        
        
        
        
        
        /*
         ==============================
         Establish Entity Relationships
         ==============================
        */

        // ❎ Establish Relationship between entities Song and Thumbnail
        newPark.photo = newPhoto
        newPark.audio = newAudio
        newAudio.park = newPark
        newPhoto.park = newPark

        /*
         ==================================
         Save Changes to Core Data Database
         ==================================
        */

        // ❎ CoreData Save operation
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
   }
    
    func microphoneTapped() {
          if audioRecorder == nil {
              self.recordingVoice = true
              startRecording()
          } else {
              self.recordingVoice = false
              finishRecording()
          }
      }
    
    
    func microphoneTapped2() {
        if recordingVoice2 {
            cancelRecording()
            self.recordingVoice2 = false
        } else {
            self.recordingVoice2 = true
            recordAndRecognizeSpeech()
        }
    }
    
    func recordAndRecognizeSpeech() {
        //--------------------
        // Set up Audio Buffer
        //--------------------
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }
       
        //---------------------
        // Prepare Audio Engine
        //---------------------
        audioEngine.prepare()
       
        //-------------------
        // Start Audio Engine
        //-------------------
        do {
            try audioEngine.start()
        } catch {
            print("Unable to start Audio Engine!")
            return
        }
       
        //-------------------------------
        // Convert recorded voice to text
        //-------------------------------
        recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: { result, error in
           
            if result != nil {  // check to see if result is empty (i.e. no speech found)
                if let resultObtained = result {
                    let bestString = resultObtained.bestTranscription.formattedString
                    self.speechConvertedToText = bestString
                    
                } else if let error = error {
                    print("Transcription failed, but will continue listening and try to transcribe. See \(error)")
                }
            }
        })
    }
    
    func cancelRecording() {
        request.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionTask?.finish()
    }
    
    func startRecording() {
    
         let audioFileName = idAndFilename.uuidString + ".m4a"
         let audioFilenameUrl = documentDirectory.appendingPathComponent(audioFileName)
    
         let settings = [
             AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
             AVSampleRateKey: 12000,
             AVNumberOfChannelsKey: 1,
             AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
         ]
    
         do {
             audioRecorder = try AVAudioRecorder(url: audioFilenameUrl, settings: settings)
             audioRecorder.record()
         } catch {
             finishRecording()
         }
     }
 
    
    func finishRecording() {
          audioRecorder.stop()
          audioRecorder = nil
          self.recordingVoice = false
      }
}
 
 
