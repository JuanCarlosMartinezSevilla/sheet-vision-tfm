//
//  DataProcessing.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 16/5/23.
//

import Foundation
import SwiftUI


func processImage(image: UIImage) async {
    guard let url = URL(string: "https://flask-production-9399.up.railway.app/document_analysis") else {
        // Handle invalid URL error
        return
    }
    
    guard let imageData = image.pngData() else {
        // Handle image data conversion error
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("image/png", forHTTPHeaderField: "Content-Type")
    request.httpBody = imageData
    
    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        print(data)
        // Process the response data
        // ...
    } catch {
        // Handle error
        // ...
    }
}

