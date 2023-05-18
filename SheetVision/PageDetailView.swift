//
//  PageDetailView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 4/5/23.
//

import SwiftUI

struct PageDetailView: View {
    var page: Page
    var fileManager: LocalFileManager?
    
    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: drawRectanglesOnImage(regions: page.regions?.array as? [Region] ?? [], image: fileManager!.loadImage(imageName: page.id!.uuidString)!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text(page.score?.name ?? "")
                
                
                
                Text("Region Count: \(page.regions?.count ?? 0)")
                
                ForEach(page.regions?.array as? [Region] ?? [], id: \.self) { region in
                    VStack(alignment: .leading) {
                        ImageCropView(region: region, image: fileManager!.loadImage(imageName: page.id!.uuidString)!)
                        Text("FromX: \(region.fromX) FromY: \(region.fromY) ToX: \(region.toX) ToY: \(region.toY)")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

func drawRectanglesOnImage(regions: [Region], image: UIImage) -> UIImage? {
    // Begin image context
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    
    // Draw the original image
    image.draw(at: CGPoint.zero)
    
    // Set rectangle color and line width
    let rectangleColor = UIColor.red
    let lineWidth: CGFloat = 10.0
    
    
    // Iterate through regions and draw rectangles
    for region in regions {
        let fromX = CGFloat(region.fromX)
        let fromY = CGFloat(region.fromY)
        let toX = CGFloat(region.toX)
        let toY = CGFloat(region.toY)
        
        let rect = CGRect(x: fromX, y: fromY, width: toX - fromX, height: toY - fromY)
        // Create a bezier path for the rectangle
        let path = UIBezierPath(rect: rect)
        
        // Set the line width and stroke color
        path.lineWidth = lineWidth
        rectangleColor.setStroke()
        path.stroke()
    }
    
    // Get the new image from the image context
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    
    // End image context
    UIGraphicsEndImageContext()
    
    return newImage
}
