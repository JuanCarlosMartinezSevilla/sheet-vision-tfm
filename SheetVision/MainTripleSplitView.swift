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
    @State private var path: [Page] = []
    private var fileManager = LocalFileManager.instance
    
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
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
            if let scores = selectedCollection?.scores as? NSOrderedSet ?? NSOrderedSet() {
                
                let scoresArray = scores.array as? [Score] ?? []
                
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
            NavigationStack(path: $path) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        
                        if let pages = selectedScore?.pages as? NSOrderedSet ?? NSOrderedSet() {
                            
                            let pagesArray = pages.array as? [Page] ?? []
                            
                            ForEach(pagesArray, id: \.self) { name in
                                NavigationLink(value: name) {
                                    VStack {
                                        ZStack {
                                            Image(uiImage: fileManager.loadImage(imageName: name.id!.uuidString)!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .colorMultiply(name.isDone ? .clear : .gray)
                                            
                                            if !name.isDone {
                                                VStack{
                                                    Image(systemName: "exclamationmark.triangle.fill")
                                                        .font(.system(size: 50))
                                                        .foregroundColor(.yellow)
                                                    Text("Not processed")
                                                        .bold()
                                                        .font(.caption)
                                                        
                                                }
                                            }
                                        }
                                        
                                        Text((name.id?.uuidString.prefix(4))!)
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
                    
                    
                    ScannerView(score: selectedScore, moc: moc, fileManager: fileManager)
                    //AnotherCameraView()
                    //CameraView(viewModel: ContentViewModel())
                    
                }
                .navigationDestination(for: Page.self) {
                    page in
                    PageDetailView(page: page, fileManager: fileManager)
                    
                }
                .navigationTitle("Pages")
            }
        }
    }
    
}

struct MainTripleSplitView_Previews: PreviewProvider {
    static var previews: some View {
        MainTripleSplitView()
    }
}
