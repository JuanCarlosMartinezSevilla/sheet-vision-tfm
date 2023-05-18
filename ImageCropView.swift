//
//  ImageCropView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 18/5/23.
//

import SwiftUI

import SwiftUI

struct ImageCropView: View {
    var region: Region
    var image: UIImage
    
    var body: some View {
            Image(uiImage: croppedImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
            WordGridView(words: region.sequence!.components(separatedBy: " "), columns: 4)
    }
    
    private func croppedImage() -> UIImage {
        let scale = image.scale
        
        
        let fromX = CGFloat(region.fromX)
        let fromY = CGFloat(region.fromY)
        let toX = CGFloat(region.toX)
        let toY = CGFloat(region.toY)
        
        let cropRect = CGRect(x: fromX, y: fromY, width: toX - fromX, height: toY - fromY)
        
        if let croppedImage = image.cgImage?.cropping(to: cropRect) {
            return UIImage(cgImage: croppedImage, scale: scale, orientation: image.imageOrientation)
        } else {
            return image
        }
    }
}

struct WordGridView: View {
    let words: [String]
    let columns: Int
    
    var body: some View {
        VStack {
            ForEach(0..<rowCount, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<columns) { column in
                        let index = row * columns + column
                        if index < words.count {
                            Text("\(index + 1): \(words[index])")
                                .padding(8)
                                .border(Color.gray)
                        }
                    }
                }
            }
        }
    }
    
    private var rowCount: Int {
        (words.count + columns - 1) / columns
    }
}


//struct ImageCropView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageCropView()
//    }
//}
