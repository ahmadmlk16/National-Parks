//
//  StateParkItem.swift
//  NationalParks
//
//  Created by Mohsin on 4/12/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import SwiftUI
 
struct StateParkItem: View {
    // Input Parameter
    let Npark: NationalPark
   
    var body: some View {
        HStack {
            getImageFromUrl(url: Npark.images[0].url)
            .resizable()
                          .aspectRatio(contentMode: .fit)
                          .frame(width: 80.0, height: 80.0)
            VStack(alignment: .leading) {
                Text(Npark.fullName)
                Text(Npark.states)
            }
            .font(.system(size: 14))
        }
    }
}
 
 
struct StateParkItem_Previews: PreviewProvider {
    static var previews: some View {
        StateParkItem(Npark: park)
    }
}
 
 
