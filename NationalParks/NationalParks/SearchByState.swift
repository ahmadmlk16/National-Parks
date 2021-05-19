//
//  SearchByState.swift
//  NationalParks
//
//  Created by Mohsin on 4/12/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import Foundation
import SwiftUI

// Global array of park structs
var foundParksList = [NationalPark]()

/*
 Register as a developer for park Search API at https://developer.edamam.com/,
 obtain your own App ID and App Key, and use them in your app.
 */


fileprivate var previousQuery = ""

/*
 -----------------------------------------------------
 MARK: - Get parks Data from API for the Given Query
 -----------------------------------------------------
 */
public func getStateParks(apiQueryUrl: String) {
    
    

    let indexComma = apiQueryUrl.firstIndex(of: "(")!
    var url = apiQueryUrl[indexComma..<apiQueryUrl.endIndex]
    url.removeLast()
    url.removeFirst()
    
    let Url = String(url)
    
    
    // Avoid executing this function if already done for the same apiQueryUrl
    if Url == previousQuery {
        return
    } else {
        previousQuery = Url
    }
    
    // Clear out previous content in the global array
    foundParksList = [NationalPark]()
    
    
    /*
     *********************************************
     *   Obtaining API Search Query URL Struct   *
     *********************************************
     */
    
    var apiQueryUrlStruct: URL?
    
    if let urlStruct = URL(string: "https://developer.nps.gov/api/v1/parks?stateCode=\(String(Url))&fields=images") {
        apiQueryUrlStruct = urlStruct
    } else {
        // foodItem will have the initial values set as above
        return
    }
    
    /*
     *******************************
     *   HTTP GET Request Set Up   *
     *******************************
     */
    
    let headers = [
        "x-api-key": "K6aOZjpGarVQdiqL1Ku6pMsiUV88FXbBrLweQnpb",
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "developer.nps.gov"
    ]
    
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 60.0)
    
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
    /*
     *********************************************************************
     *  Setting Up a URL Session to Fetch the JSON File from the API     *
     *  in an Asynchronous Manner and Processing the Received JSON File  *
     *********************************************************************
     */
    
    /*
     Create a semaphore to control getting and processing API data.
     signal() -> Int    Signals (increments) a semaphore.
     wait()             Waits for, or decrements, a semaphore.
     */
    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
         URLSession is established and the JSON file from the API is set to be fetched
         in an asynchronous manner. After the file is fetched, data, response, error
         are returned as the input parameter values of this Completion Handler Closure.
         */
        
        // Process input parameter 'error'
        guard error == nil else {
            semaphore.signal()
            return
        }
        
        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            semaphore.signal()
            return
        }
        
        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        guard let jsonDataFromApi = data else {
            semaphore.signal()
            return
        }
        
        //------------------------------------------------
        // JSON data is obtained from the API. Process it.
        //------------------------------------------------
        do {
            /*
             Foundation framework’s JSONSerialization class is used to convert JSON data
             into Swift data types such as Dictionary, Array, String, Number, or Bool.
             */
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                                options: JSONSerialization.ReadingOptions.mutableContainers)
            
            //------------------------------------------
            // Obtain Top Level JSON Object (Dictionary)
            //------------------------------------------
            var topLevelDictionary = Dictionary<String, Any>()
            
            if let jsonObject = jsonResponse as? [String: Any] {
                topLevelDictionary = jsonObject
            } else {
                semaphore.signal()
                // foundparksList will be empty
                return
            }
            
            //------------------------------------
            // Obtain Array of "hits" JSON Objects
            //------------------------------------
            var arrayOfHitsJsonObjects = Array<Any>()
            
            if let jsonArray = topLevelDictionary["data"] as? [Any] {
                arrayOfHitsJsonObjects = jsonArray
            } else {
                semaphore.signal()
                // foundparksList will be empty
                return
            }
            
            for index in 0..<arrayOfHitsJsonObjects.count {
                
                //-------------------------
                // Obtain park Dictionary
                //-------------------------
                
                
                var foodsJsonObject = [String: Any]()
                if let jsonDictionary = arrayOfHitsJsonObjects[index] as? [String: Any] {
                    foodsJsonObject = jsonDictionary
                } else {
                    semaphore.signal()
                    return
                }
                
                
                
                //----------------
                // Initializations
                //----------------
                
                var fullName = ""
                var states = ""
                var websiteUrl = ""
                var latitude = 0.0
                var longitude = 0.0
                var description = ""
                var images =  [ParkPhoto]()
                
                
                if let name = foodsJsonObject["fullName"] as? String {
                    fullName = name
                }
                
                
                if let st = foodsJsonObject["states"] as? String {
                    states = st
                }
                
                if let url = foodsJsonObject["url"] as? String {
                    websiteUrl = url
                }
                
                if let desc = foodsJsonObject["description"] as? String {
                    description = desc
                }
                
                if let latlong = foodsJsonObject["latLong"] as? String {
                    let l = latlong
                    if (l.count > 5){
                        let indexComma = l.firstIndex(of: ",")!
                        
                        
                        var long = l[indexComma..<l.endIndex]
                        long.removeFirst()
                        long.removeFirst()
                        long.removeFirst()
                        long.removeFirst()
                        long.removeFirst()
                        long.removeFirst()
                        long.removeFirst()
                        
                        
                        var lat = l[l.startIndex..<indexComma]
                        lat.removeFirst()
                        lat.removeFirst()
                        lat.removeFirst()
                        lat.removeFirst()
                        
                        latitude = Double(lat) ?? 0.0
                        longitude = Double(long) ?? 0.0
                        
                    }
                    else{
                        latitude = 0.0
                        longitude = 0.0                         }
                    
                }
                
                
                
                 var imagesJsonArray = [Any]()
                           if let jArray = foodsJsonObject["images"] as? [Any] {
                               imagesJsonArray = jArray
                           }
                           var imagesJsonObject = [String: Any]()
                           var i = 0

                if (imagesJsonArray.count == 0){
                    images.append(ParkPhoto(id: UUID(), url: "", caption: "No images are availbe for this park"))
                }
                           for _ in imagesJsonArray{
                               
                               if let jObject = imagesJsonArray[i] as?[String: Any]{
                                   imagesJsonObject = jObject
                                   i = i + 1
                                   
                                   
                                   var url = ""
                                   var cap = ""
                                   
                                   
                                   
                                   // feed values from json into global foundCat
                                   
                                   if let u = imagesJsonObject["url"]as? String{
                                       url = u
                                   }
                                   if let c = imagesJsonObject["caption"]as? String{
                                       cap = c
                                   }

                                   //append the new News item into the list
                                images.append(ParkPhoto(id: UUID(), url: url, caption: cap))
                                   
                                   
                                   
                               }else{
                                   semaphore.signal()
                                   return
                               }
                               
                           }
                
                
                park = NationalPark(id: UUID(), fullName: fullName, states: states, websiteUrl: websiteUrl, latitude: latitude, longitude: longitude, description: description, images: images)
                
                
                
                foundParksList.append(park)
                
                
                
                
                
            }   // End of the for loop
            
        } catch {
            semaphore.signal()
            return
        }
        
        semaphore.signal()
    }).resume()
    
    /*
     The URLSession task above is set up. It begins in a suspended state.
     The resume() method starts processing the task in an execution thread.
     
     The semaphore.wait blocks the execution thread and starts waiting.
     Upon completion of the task, the Completion Handler code is executed.
     The waiting ends when .signal() fires or timeout period of 10 seconds expires.
     */
    
    _ = semaphore.wait(timeout: .now() + 10)
    
}

