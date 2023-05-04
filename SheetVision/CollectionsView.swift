//
//  CollectionsView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 4/5/23.
//

import SwiftUI

struct MusicCollection: Identifiable, Hashable {
    let id = UUID()
    let name: String
}


struct CollectionsView: View {
    
    let musicCollections = ["Jazz Classics", "Pop Hits", "Rock Anthems", "Country Jams", "Classical Masterpieces"]
    
    var randomCollections: [MusicCollection] {
        var collections = [MusicCollection]()
        for i in 1...5 {
            let randomIndex = Int.random(in: 0..<musicCollections.count)
            let randomName = musicCollections[randomIndex]
            let collection = MusicCollection(name: "\(randomName) Collection \(i)")
            collections.append(collection)
        }
        return collections
    }
    
    @State private var selectedCollection: MusicCollection?
    
    var body: some View {
        
        List(randomCollections, selection: $selectedCollection) { collection in
            NavigationLink(collection.name) {
                ScoresView()
            }
            //Navigation(collection.name, value: collection.name)
            
        }.toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Text("Add collection")
                } label: {
                    Label("Add collection", systemImage: "plus")
                }
            }
        }
        .navigationBarTitle("Collections")
    }
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionsView()
    }
}
