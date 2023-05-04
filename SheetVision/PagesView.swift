//
//  PagesView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 4/5/23.
//

import SwiftUI

struct PagesView: View {
    let names = ["Alice", "Bob", "Charlie", "David", "Emma", "Frank", "George", "Hannah", "Isabella", "Jack", "Kate", "Liam", "Mia", "Nathan", "Olivia", "Peter", "Quinn", "Rachel", "Sarah", "Tom", "Una", "Victoria", "William", "Xander", "Yara", "Zoe"]
        
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
        
        var randomNames: [String] {
            var random = [String]()
            for i in 1...9 {
                let randomIndex = Int.random(in: 0..<names.count)
                let name = names[randomIndex]
                random.append("\(name) \(i)")
            }
            return random
        }
    
//    @State private var selectedPage: Page?
//    @State private var path: [Page] = []
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(randomNames, id: \.self) { name in
                        NavigationLink(name) {
                            PageDetailView()
                        }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }.toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Text("Scan score")
                    } label: {
                        Label("Scan score", systemImage: "camera")
                    }
                }
            }.navigationTitle("Pages")
//                .navigationDestination(for: Page.self) {                    page in PageDetailView(page: } 
        }
}

struct PagesView_Previews: PreviewProvider {
    static var previews: some View {
        PagesView()
    }
}
