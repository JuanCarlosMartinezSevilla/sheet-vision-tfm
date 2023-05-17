//
//  ScannerView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla.
//

import SwiftUI
import VisionKit
import CoreData

struct DocumentScannerView: UIViewControllerRepresentable {
    @Binding var scannedDocuments: [UIImage]
    @Environment(\.presentationMode) var presentationMode
    
    func makeCoordinator() -> Coordinator {
        print("makeCoordinator")
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        print("makeUIViewController")
        let documentCameraViewController = VNDocumentCameraViewController()
        
        documentCameraViewController.delegate = context.coordinator
        return documentCameraViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        // Update the view controller if needed
        print("updateUIViewController")
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let parent: DocumentScannerView
        
        init(parent: DocumentScannerView) {
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            
            print("documentCameraViewController")
            guard scan.pageCount > 0 else {
                controller.dismiss(animated: true) {
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
                return
            }
            
            let scannedImage = scan.imageOfPage(at: 0)
            for i in 0...scan.pageCount-1 {
                parent.scannedDocuments.append(scan.imageOfPage(at: i))
            }
            
            controller.dismiss(animated: true) {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true) {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
            print("documentCameraViewControllerDidCancel")
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            // Handle error
            print(error)
        }
    }
}

struct ScannerView: View {
    @State private var scannedDocuments = [UIImage]()
    @State private var isSavePictures = false
    @State private var isPresentingScanner = false
    var score: Score?
    var moc: NSManagedObjectContext
    var fileManager : LocalFileManager?
    @Environment(\.dismiss) var dismiss
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    
    var body: some View {
        
        VStack {
            Button {
                isPresentingScanner = false
                dismiss()
            } label: {
                Label("Return", systemImage: "arrowshape.backward.fill")
            }
            
            if let documents = scannedDocuments {
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        
                        ForEach(documents, id: \.self) {doc in
                            VStack {
                                Image(uiImage: doc)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                                Text("Picture")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }.padding()
                        }
                    }
                }
                if documents.count > 0 && isSavePictures{
                    Button {
                        savePictures(documents, score!, moc)
                        dismiss()
                    } label: {
                        Label("Save pictures", systemImage: "square.and.arrow.down.fill")
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
            } else {
                Text("No Document Scanned")
                    .padding()
            }
            if !isSavePictures {
                Button("Scan Document") {
                    isSavePictures = true
                    isPresentingScanner = true
                }.padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
        .fullScreenCover(isPresented: $isPresentingScanner) {
            DocumentScannerView(scannedDocuments: $scannedDocuments)
        }
    }
}

func savePictures(_ pictures: [UIImage], _ score: Score, _ moc: NSManagedObjectContext) {
    
    for p in pictures {
        fetchData(p, moc, score)
    }
}

func fetchData(_ image: UIImage, _ moc: NSManagedObjectContext, _ score: Score) {
    var fileManager = LocalFileManager.instance
    print("fetchData")
    guard let url = URL(string: "https://flask-production-9399.up.railway.app/document_analysis") else {
        return
    }
    
    guard let imageData = image.pngData() else {
        // Handle image data conversion error
        return
    }
        
        // Create a boundary string for the multipart form data
        let boundary = UUID().uuidString
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        // Append the image data to the body
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Close the form data
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body as Data
        
    
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
            return
        }
        // convert to JSON
        do {
            
            let pred = try JSONDecoder().decode(Prediction.self, from: data)
            DispatchQueue.main.async {
                print("PRED: \(pred)")
                let newPage = Page(context: moc)
                newPage.id = UUID()
                fileManager.saveImage(image: image, imageName: newPage.id!.uuidString)
                newPage.isDone = true
                newPage.score = score
                
                for customRegion in pred.prediction {
                    let region = Region(context: moc)
                    region.fromX = Int16(customRegion.fromX)
                    region.fromY = Int16(customRegion.fromY)
                    region.toX = Int16(customRegion.toX)
                    region.toY = Int16(customRegion.toY)
                    region.sequence = customRegion.seq.joined(separator: " ")
                }

                try? moc.save()
            }
        }
        catch let error {
            print("Error decoding JSON \(error)")
        }
    }
    task.resume()
}

struct CustomRegion: Hashable, Codable {
    let fromX : Int
    let fromY : Int
    let toX : Int
    let toY : Int
    let seq : [String]
}

struct Prediction: Hashable, Codable {
    let prediction : [CustomRegion]
}
