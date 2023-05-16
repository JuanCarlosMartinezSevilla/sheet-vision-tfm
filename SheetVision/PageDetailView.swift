//
//  PageDetailView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 4/5/23.
//

import SwiftUI

struct PageDetailView: View {
    var page : Page
    var fileManager: LocalFileManager?
    
    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: fileManager!.loadImage(imageName: page.id!.uuidString)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                if page.isDone {
                    ForEach(0..<3) { index in
                        VStack {
                            Image("crop\(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                            Text("Crop \(index + 1)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
