//
//  ImageUtils.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 16/5/23.
//

import Foundation
import SwiftUI

func saveImage(image: UIImage, name: UUID) -> URL? {
    
    guard let data = image.jpegData(compressionQuality: 0.8) else {
        return nil
    }
    
    let directoryURL = getDocumentsDirectory().appendingPathComponent("SheetVision")
    
    do {
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        
        let imageName = name.uuidString + ".jpeg"
        let fileURL = directoryURL.appendingPathComponent(imageName)
        
        try data.write(to: fileURL)
        print("Image saved successfully")
        return fileURL
        
        
    } catch {
        print("Error saving image: \(error.localizedDescription)")
        return nil
    }
}

func loadImage(_ path: String) -> UIImage? {
    let fileURL = getDocumentsDirectory().appendingPathComponent(path)
    
    if FileManager.default.fileExists(atPath: fileURL.path) {
        if let imageData = try? Data(contentsOf: fileURL) {
            return UIImage(data: imageData)
        }
    }
    
    return nil
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
