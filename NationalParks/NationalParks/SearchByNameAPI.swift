//
//  SearchByNameAPI.swift
//  NationalParks
//
//  Created by Mohsin on 4/10/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import Foundation




// Declare parkItem as a global mutable variable accessible in all Swift files

var park = NationalPark(id: UUID(), fullName: "", states: "", websiteUrl: "", latitude: 0.0, longitude: 0.0, description: "", images: [ParkPhoto]())



/*
 =================================================================
 Get Nutrition Data from the API for the park Item with UPC.
 Universal Product Code (UPC) is a barcode symbology consisting of
 12 numeric digits that are uniquely assigned to a trade item.
 =================================================================
 */
public func SearchPark(query: String) {
    
    /*
     Create an empty instance of parkStruct defined in parkStruct.swift
     Assign its unique id to the global variable parkItem
     */
    park = NationalPark(id: UUID(), fullName: "", states: "", websiteUrl: "", latitude: 0.0, longitude: 0.0, description: "", images: [ParkPhoto]() )
    
    /*
     *********************************************
     *   Obtaining API Search Query URL Struct   *
     *********************************************
     */
    
    var apiQueryUrlStruct: URL?
    
    if let urlStruct = URL(string: "https://developer.nps.gov/api/v1/parks?q=\(query)&fields=images") {
        apiQueryUrlStruct = urlStruct
    } else {
        // parkItem will have the initial values set as above
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
            
            /*
             JSON object with Attribute-Value pairs corresponds to Swift Dictionary type with
             Key-Value pairs. Therefore, we use a Dictionary to represent a JSON object
             where Dictionary Key type is String and Value type is Any (instance of any type)
             */
            var jsonDataDictionary = Dictionary<String, Any>()
            
            if let jsonObject = jsonResponse as? [String: Any] {
                jsonDataDictionary = jsonObject
            } else {
                semaphore.signal()
                return
            }
            
            //------------------------
            // Obtain parks JSON Array
            //------------------------
            
            var parksJsonArray = [Any]()
            if let jArray = jsonDataDictionary["data"] as? [Any] {
                parksJsonArray = jArray
            } else {
                semaphore.signal()
                return
            }
            
            //-------------------------
            // Obtain parks JSON Object
            //-------------------------
            
            var parksJsonObject = [String: Any]()
            if let jObject = parksJsonArray[0] as? [String: Any] {
                parksJsonObject = jObject
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
            
            //------------------
            // Obtain Brand Name
            //------------------
            
            if let name = parksJsonObject["fullName"] as? String {
                fullName = name
            }else{
                semaphore.signal()
                return
            }
            
            
            var l = 1
            while (fullName !=  query.replacingOccurrences(of: "+", with: " ") && l < parksJsonArray.count  ){
                if let jObject = parksJsonArray[l] as? [String: Any] {
                    parksJsonObject = jObject
                    l = l + 1
                } else {
                    semaphore.signal()
                    return
                }
                
                if let name = parksJsonObject["fullName"] as? String {
                    fullName = name
                }
            }
            //-----------------
            // Obtain park Name
            //-----------------
            
            if let st = parksJsonObject["states"] as? String {
                states = st
            }
            
            if let url = parksJsonObject["url"] as? String {
                websiteUrl = url
            }
            
            if let desc = parksJsonObject["description"] as? String {
                description = desc
            }
            
            if let latlong = parksJsonObject["latLong"] as? String {
                let l = latlong
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
            
            
            
            
            var imagesJsonArray = [Any]()
            if let jArray = parksJsonObject["images"] as? [Any] {
                imagesJsonArray = jArray
            }
            var imagesJsonObject = [String: Any]()
            var i = 0

            
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
    
    _ = semaphore.wait(timeout: .now() + 60)
    
}


