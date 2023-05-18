//
//  RequestHandler.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 18/5/23.
//

import Foundation
import SwiftUI
import CoreData

func createRequestBody(imageData: Data, boundary: String, attachmentKey: String, fileName: String) -> Data{
    let lineBreak = "\r\n"
    var requestBody = Data()
    
    requestBody.append("\(lineBreak)--\(boundary + lineBreak)" .data(using: .utf8)!)
    requestBody.append("Content-Disposition: form-data; name=\"\(attachmentKey)\"; filename=\"\(fileName)\"\(lineBreak)" .data(using: .utf8)!)
    requestBody.append("Content-Type: image/jpeg \(lineBreak + lineBreak)" .data(using: .utf8)!) // you can change the type accordingly if you want to
    requestBody.append(imageData)
    requestBody.append("\(lineBreak)--\(boundary)--\(lineBreak)" .data(using: .utf8)!)
    
    return requestBody
}

func fetchData(_ image: UIImage, _ moc: NSManagedObjectContext, _ page: Page) {
    
    print("fetchData")
    
    guard let imageData = image.jpegData(compressionQuality: 0.9) else {
        // Handle image data conversion error
        return
    }
    
    let url =  "https://flask-production-9399.up.railway.app/document_analysis"
    var urlRequest = URLRequest(url: URL(string: url)!)
    
    urlRequest.httpMethod = "post"
    let bodyBoundary = "--------------------------\(UUID().uuidString)"
    urlRequest.addValue("multipart/form-data; boundary=\(bodyBoundary)", forHTTPHeaderField: "Content-Type")
    
    //attachmentKey is the api parameter name for your image do ask the API developer for this
    // file name is the name which you want to give to the file
    let requestData = createRequestBody(imageData: imageData, boundary: bodyBoundary, attachmentKey: "image", fileName: "image.jpeg")
    
    urlRequest.addValue("\(requestData.count)", forHTTPHeaderField: "content-length")
    urlRequest.httpBody = requestData
    
    URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
        
        if(error == nil && data != nil && data?.count != 0){
            guard let httpResponse = httpUrlResponse as? HTTPURLResponse else {
                // Handle invalid response
                print("Invalid response")
                return
            }
            
            guard let data = data else {
                // Handle empty data
                print("Empty data")
                return
            }
            
            // Handle HTTP status code
            let statusCode = httpResponse.statusCode
            print("Status Code: \(statusCode)")
            do {
                let response = try JSONDecoder().decode([CustomRegion].self, from: data)
                print(response)
                for r in response {
                    let newRegion = Region(context: moc)
                    newRegion.toX = Int16(r.toX)
                    newRegion.toY = Int16(r.toY)
                    newRegion.fromX = Int16(r.fromX)
                    newRegion.fromY = Int16(r.fromY)
                    newRegion.sequence = r.seq.joined(separator: " ")
                    newRegion.page = page
                    page.isDone = true
                    
                    try? moc.save()
                }
            }
            
            catch let decodingError {
                debugPrint(decodingError)
            }
        }
    }.resume()
}

struct CustomRegion: Hashable, Codable {
    let fromX : Int
    let fromY : Int
    let toX : Int
    let toY : Int
    let seq : [String]
}
