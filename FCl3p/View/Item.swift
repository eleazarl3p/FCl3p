//
//  Item.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/11/23.
//

import SwiftUI

struct Item: View {
    let name : String
    let dateCreated : Date
    var body: some View {
        VStack (alignment: .leading){
            Text(name)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            Text(dateCreated.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
        }.padding(.horizontal, 5)
    }
}

#Preview {
    Item(name: "A", dateCreated: Date.now)
}
