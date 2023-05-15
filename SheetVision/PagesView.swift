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
        for i in 1...20 {
            let randomIndex = Int.random(in: 0..<names.count)
            let name = names[randomIndex]
            random.append("\(name) \(i)")
        }
        return random
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(randomNames, id: \.self)
                { name in
                    NavigationLink(destination: PageDetailView()) {
                        VStack {
                            Image("scoreExample")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Text(name)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }.padding()
                    }
                    
                    
                }
                
            }
        }.toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Handle click event
                    //handleClick()
                }) {
                    Image(systemName: "camera")
                }
            }
        }.navigationTitle("Pages")
        
    }
    
}
    
    struct PagesView_Previews: PreviewProvider {
        static var previews: some View {
            PagesView()
        }
    }
