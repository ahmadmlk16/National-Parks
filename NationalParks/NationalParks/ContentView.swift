//
//  ContentView.swift
//  NationalParks
//
//  Created by Mohsin on 4/9/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import SwiftUI
 
struct ContentView: View {
 
    var body: some View {
 
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            ParksVisited()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Parks Visited")
                }
            SearchName()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search By Name")
                }
            SearchState()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search By State")
                }
        }   // End of TabView
        .font(.headline)
        .imageScale(.medium)
        .font(Font.title.weight(.regular))
    }
}
 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
