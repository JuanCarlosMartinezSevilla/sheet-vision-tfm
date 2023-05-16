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
    @State private var isPresentingCameraFullScreen = false
    @State private var selectedCollection: Collection?
    @State private var selectedScore: Score?
    
    // pages view
    let names = ["Alice", "Bob", "Charlie", "David", "Emma", "Frank", "George", "Hannah", "Isabella", "Jack", "Kate", "Liam", "Mia", "Nathan", "Olivia", "Peter", "Quinn", "Rachel", "Sarah", "Tom", "Una", "Victoria", "William", "Xander", "Yara", "Zoe"]
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var randomNames: [String] {
        var random = [String]()
        for i in 1...20 {
            let randomIndex = Int.random(in: 0..<names.count)
            let name = names[randomIndex]
            random.append("\(name) \(i)")
        }
        return random
    }
    
    
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
            //CameraView(viewModel: ContentViewModel())
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {

                    if let pages = selectedScore?.pages as? Set<Page> ?? Set<Page>() {
                        let pagesArray = Array(pages)

                        ForEach(pagesArray, id: \.self) { name in
                            NavigationLink(destination: PageDetailView()) {
                                VStack {
                                    Image(uiImage: loadImage(name.image!)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        
                                    Text("a")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }.padding()
                            }
                        }
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Handle click event
                        print("PUSHING CAMERA VIEW")
                        isPresentingCameraFullScreen = true
                    }) {
                        Image(systemName: "camera")
                    }
                }
            }.fullScreenCover(isPresented: $isPresentingCameraFullScreen) {
                
                ScannerView(score: selectedScore!)
                //AnotherCameraView()
               //CameraView(viewModel: ContentViewModel())
                
            }
            .navigationTitle("Pages")
            
        }
    }
    
}

struct MainTripleSplitView_Previews: PreviewProvider {
    static var previews: some View {
        MainTripleSplitView()
    }
}
