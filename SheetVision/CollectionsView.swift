//
//  CollectionsView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 4/5/23.
//

import SwiftUI



struct CollectionsView: View {
    
//    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(sortDescriptors: [
//        SortDescriptor(\.name),
//        SortDescriptor(\.colDescription)
//    ]) var collection: FetchedResults<Collection>
    
    @State private var showingAddCollectionScreen = false
    
    @State private var selectedCollection: Collection?
    
    var body: some View {
        
        //        List(randomCollections, selection: $selectedCollection) { collection in
        //            NavigationLink(collection.name) {
        //                ScoresView()
        //            }
        //            //Navigation(collection.name, value: collection.name)
        //
        //        }.toolbar {
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
        //        .navigationBarTitle("Collections")
        //    }
        Text("main")
    }
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionsView()
    }
}
