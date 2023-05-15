//
//  MainTripleSplitView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 4/5/23.
//

import SwiftUI


struct MainTripleSplitView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var collections: FetchedResults<Collection>
    
    @State private var showingAddCollectionScreen = false
    @State private var showingAddScoreScreen = false
    @State private var selectedCollection: Collection?
    @State private var selectedScore: Score?
    
    
    var body: some View {
        NavigationSplitView {
            List(collections, selection: $selectedCollection) { collection in
                NavigationLink(value: collection) {
                    VStack(alignment: .leading) {
                        Text(collection.name!).font(.title2)
                        Text(collection.colDescription!).font(.caption)
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddCollectionScreen.toggle()
                    } label: {
                        Label("Add Collection", systemImage: "plus")
                    }
                }
            }.sheet(isPresented: $showingAddCollectionScreen) {
                AddCollectionView()
            }
            .navigationBarTitle("Collections")
        } content: {
            if let scores = selectedCollection?.scores as? Set<Score> ?? Set<Score>() {
                let scoresArray = Array(scores)
                
                List(scoresArray, id: \.self, selection: $selectedScore) { score in
                    
                    NavigationLink(value: score) {
                        VStack(alignment: .leading) {
                            Text(score.name!).font(.title3)
                                .bold()
                            Text("Author: \(score.author!)")
                        }
                    }
                }.toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddScoreScreen.toggle()
                        } label: {
                            Label("Add Collection", systemImage: "plus")
                        }
                    }
                }.sheet(isPresented: $showingAddScoreScreen) {
                    AddScoreView(collection: selectedCollection)
                }
                .navigationBarTitle("Scores")
            }
        } detail: {
            PagesView()
        }
    }
}

struct MainTripleSplitView_Previews: PreviewProvider {
    static var previews: some View {
        MainTripleSplitView()
    }
}
