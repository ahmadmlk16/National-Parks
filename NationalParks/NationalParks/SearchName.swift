//
//  SearchName.swift
//  NationalParks
//
//  Created by Mohsin on 4/10/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import SwiftUI
 
struct SearchName: View {
   
    @State private var searchTextFieldValue = ""
    @State private var searchStringEntered = ""
   

   
    var body: some View {
       
        NavigationView {
            Form {

                Section(header:
                    Text("Enter search string and then press the Return key")
                ) {
                    HStack {
                        /*
                         🔴 When the user enters a character in the TextField,
                         searchTextFieldValue changes upon which the body View is refreshed.
                         When the user hits Return on keyboard, the entire search string is
                         put into searchStringEntered upon which the body View is refreshed.
                         */
                        TextField("Enter Search String", text: $searchTextFieldValue,
                            onCommit: {
                                // Record entered value after Return key is pressed
                                self.searchStringEntered = self.searchTextFieldValue
                            }
                        )   // End of TextField
 
                        // Keyboard Types: .decimalPad, .default, .emailAddress,
                        // .namePhonePad, .numberPad, .numbersAndPunctuation
                        .keyboardType(.default)
 
                        // Options: .allCharacters, .none, .sentences, .words
                        // Ternary Operator: condition ? value1 : value2

 
                        // Turn off auto correction
                        .disableAutocorrection(true)
                       
                        // Button to clear the text field
                        Button(action: {
                            self.searchTextFieldValue = ""
                            self.searchStringEntered = ""
                        }) {
                            Image(systemName: "multiply.circle")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                }   // End of Section
               
                // Show this section only after Return key is pressed
                if !searchStringEntered.isEmpty {
                    Section(header: Text("List Details of \(searchStringEntered)")) {
                        NavigationLink(destination: searchCountry) {
                            Image(systemName: "list.bullet")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
            }   // End of Form
            .navigationBarTitle(Text("Search a National Park"), displayMode: .inline)
           
        }   // End of NavigationView
    }
   
    var searchCountry: some View {
       
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let searchStringTrimmed = searchStringEntered.trimmingCharacters(in: .whitespacesAndNewlines)
       
        if (searchStringTrimmed.isEmpty) {
            // Show error message in another view
            return AnyView(errorMessage1)
        }
       
        var searchQuery = searchStringTrimmed.lowercased()
       
        searchQuery = searchQuery.replacingOccurrences(of: " ", with: "+")
        // public function obtainCountryDataFromApi is given in CountryApiData.swift
        SearchPark(query: searchQuery)
 
        if park.fullName.isEmpty {
            return AnyView(errorMessage2)
        }
 
        return AnyView(ParkDetails(Npark: park))
    }
   
    var errorMessage1: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.red)
            Text("The Search Field is Empty.\nPlease enter a search string!")
                .padding()
                .multilineTextAlignment(.center)
        }
    }
   
    var errorMessage2: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.red)
            Text("No Country Found!\nPlease enter a valid search query for the search category selected!")
                .font(.body)    // Needed for the text to wrap around
                .padding()
                .multilineTextAlignment(.center)
        }
    }
}
 

struct SearchName_Previews: PreviewProvider {
    static var previews: some View {
        SearchName()
    }
}
