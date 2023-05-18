//
//  ScannerView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla.
//

import SwiftUI
import VisionKit
import CoreData
import Foundation

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
    var fileManager = LocalFileManager.instance
    
    for p in pictures {
        let newPage = Page(context: moc)
        newPage.id = UUID()
        fileManager.saveImage(image: p, imageName: newPage.id!.uuidString)
        newPage.score = score
        try? moc.save()
        fetchData(p, moc, newPage)
    }
}


