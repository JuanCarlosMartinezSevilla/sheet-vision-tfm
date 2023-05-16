////
////  CameraView.swift
////  SheetVision
////
////  Created by Juan Carlos Martínez Sevilla on 15/5/23.
////

//struct CameraView: View {
//
//    //    @Environment(\.presentationMode) var presentationMode
//    //
//    //    var body: some View {
//    //
//    //        ZStack {
//    //            Color.black
//    //                .ignoresSafeArea()
//    //
//    //            VStack {
//    //                Text("Full Screen View")
//    //                    .font(.largeTitle)
//    //                    .foregroundColor(.white)
//    //
//    //                Button("Dismiss") {
//    //                    presentationMode.wrappedValue.dismiss()
//    //                }
//    //                .font(.title)
//    //                .padding()
//    //                .background(Color.blue)
//    //                .foregroundColor(.white)
//    //                .cornerRadius(10)
//    //            }
//    //        }
//    //        .statusBar(hidden: true) // Optional: Hide the status bar
//
//

import SwiftUI
import VisionKit

final class ContentViewModel: NSObject, ObservableObject {
    @Published var errorMessage: String?
    @Published var imageArray: [UIImage] = []
    
    
    func getDocumentCameraViewController() -> VNDocumentCameraViewController {
        let vc = VNDocumentCameraViewController()
        vc.delegate = self
        // Customize the presentation style and transition style
        vc.modalPresentationStyle = .fullScreen
        
        
        return vc
    }
    
    func removeImage(image: UIImage) {
        imageArray.removeAll{$0 == image}
    }
}


extension ContentViewModel: VNDocumentCameraViewControllerDelegate {
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true, completion: nil)
        print("documentCameraViewControllerDidCancel")
        //getTopMostViewController()!.dismiss(animated: true)
        //        presentationMode.wrappedValue.dismiss()
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
        print("documentCameraViewController")
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        print("Did Finish With Scan.")
        
        for i in 0..<scan.pageCount {
            self.imageArray.append(scan.imageOfPage(at:i))
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

struct CameraView: View {
    @ObservedObject var viewModel: ContentViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                if let error = viewModel.errorMessage {
                    Text(error)
                } else {
                    ForEach(viewModel.imageArray, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit).contextMenu {
                                
                                Button {
                                    viewModel.removeImage(image: image)
                                } label: {
                                    Label("Delete", systemImage: "delete.left")
                                }
                            }
                    }
                }
            }
            .onAppear {
                getTopMostViewController()?.present(viewModel.getDocumentCameraViewController(), animated: true, completion: nil)
            }
        }
    }
}

// Neccesary to see the camera view
// https://developer.apple.com/forums/thread/705095

func getTopMostViewController() -> UIViewController? {
    var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
    
    while let presentedViewController = topMostViewController?.presentedViewController {
        topMostViewController = presentedViewController
    }
    return topMostViewController
}


