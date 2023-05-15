//
//  ScoresView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 4/5/23.
//

import SwiftUI
import CoreData

struct MusicScore: Identifiable {
    let id = UUID()
    let name: String
}

struct ScoresView: View {
    
    @State private var selectedScore: Collection?
    
    var body: some View {
//        List(moc.scores(in: selectedCollection), selection: $selectedScore) { score in
//            NavigationLink(score.title, value: score)
//        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    showingAddCollectionScreen.toggle()
//                } label: {
//                    Label("Add Collection", systemImage: "plus")
//                }
//            }
//        }.sheet(isPresented: $showingAddCollectionScreen) {
//            AddCollectionView()
//        }
//        .navigationBarTitle("Scores")
        Text("Scores")
        
    }
    
    
    
}

struct ScoresView_Previews: PreviewProvider {
    static var previews: some View {
        ScoresView()
    }
}
