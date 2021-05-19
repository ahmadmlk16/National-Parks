//
//  SearchState.swift
//  NationalParks
//
//  Created by Mohsin on 4/10/20.
//  Copyright © 2020 AhmadMalik. All rights reserved.
//

import SwiftUI

struct SearchState: View {
    
    @State private var searchCompleted = false
    @State private var q = 0
    let usStates = ["Alabama (AL)", "Alaska (AK)", "Arizona (AZ)", "Arkansas (AR)", "California (CA)", "Colorado (CO)", "Connecticut (CT)", "Delaware (DE)", "Florida (FL)", "Georgia (GA)", "Hawaii (HI)", "Idaho (ID)", "Illinois (IL)", "Indiana (IN)", "Iowa (IA)", "Kansas (KS)", "Kentucky (KY)", "Louisiana (LA)", "Maine (ME)", "Maryland (MD)", "Massachusetts (MA)", "Michigan (MI)", "Minnesota (MN)", "Mississippi (MS)", "Missouri (MO)", "Montana (MT)", "Nebraska (NE)", "Nevada (NV)", "New Hampshire (NH)", "New Jersey (NJ)", "New Mexico (NM)", "New York (NY)", "North Carolina (NC)", "North Dakota (ND)", "Ohio (OH)", "Oklahoma (OK)", "Oregon (OR)", "Pennsylvania (PA)", "Rhode Island (RI)", "South Carolina (SC)", "South Dakota (SD)", "Tennessee (TN)", "Texas (TX)", "Utah (UT)", "Vermont (VT)", "Virginia (VA)", "Washington (WA)", "West Virginia (WV)", "Wisconsin (WI)", "Wyoming (WY)"]
    
    var body: some View {
             NavigationView {
        Form{
            Section(header: Text("Select U.S State to Search for National Parks")){
                Picker(selection: $q, label: Text("Selected State: ")){
                    ForEach(0 ..< usStates.count){
                        Text(self.usStates[$0])
                    }
                }
            }
            Section(header: Text("Search National Parks in \(self.usStates[q])")){
                HStack{
                Button(action: {
                  getStateParks(apiQueryUrl: self.usStates[self.q])
                     self.searchCompleted = true
                     }){
                        Text(self.searchCompleted ? "Search Completed" : "Search")
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: 36, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.black, lineWidth: 1))
            }
            }
            
            if searchCompleted {
                Section(header: Text("List National Parks in \(usStates[q])")) {
                    NavigationLink(destination: StateParksList(Npark: self.usStates[q])) {
                        Image(systemName: "list.bullet")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                }
            }
        }
        .navigationBarTitle(Text("Search National Parks in a State"), displayMode: .inline)
        }
    }
}

struct SearchState_Previews: PreviewProvider {
    static var previews: some View {
        SearchState()
    }
}
