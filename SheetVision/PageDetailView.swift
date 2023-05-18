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
                Text((page.score?.name)!)
            }
            .padding()
        }
    }
}
