//
//  AnotherCameraView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 15/5/23.
//

//
//  ScannerView.swift
//  Scan-Ocr
//
//  Created by Haaris Iqubal on 5/21/21.
//

import VisionKit
import SwiftUI
import AVFoundation

struct AnotherCameraView: View {
    @StateObject var camera = CameraModel()
    
    var body: some View {
        ZStack {
            
            CameraPreview(camera: camera).ignoresSafeArea(.all, edges: .all)
            
            VStack {
                if camera.isTaken{
                    HStack {
                        Spacer()
                        
                        Button(action: camera.reTake, label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(.white)
                                .clipShape(Circle())
                        })
                        .padding(.trailing, 10)
                    }
                }
                
                Spacer()
                HStack {
                    if camera.isTaken {
                        
                        Button(action: {if !camera.isSaved{camera.savePic()}}, label: {
                            Text(camera.isSaved ? "Saved" : "Save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(.white)
                                .clipShape(Capsule())
                        }).padding()
                        Spacer()
                    }
                    else {
                        Button(action: camera.takePic, label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65,  height: 65)
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75,  height: 75)
                            }
                        })
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear(perform:  {
            camera.Check()
        })
    }
}

// Camera
class CameraModel : NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview : AVCaptureVideoPreviewLayer!
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    
    func Check() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {
                (status) in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setUp() {
        do {
            self.session.beginConfiguration()
            
            let device = AVCaptureDevice.default(for: .video)
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            self.session.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func takePic() {
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                withAnimation{
                    self.isTaken.toggle()
                }
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }
        print("pic taken")
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        
        self.picData = imageData
    }
    
    func savePic() {
        let image = UIImage(data: self.picData)!
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        print("saved")
        self.isSaved = true
    }
    
    func reTake() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation{
                    self.isTaken.toggle()
                    self.isSaved = false
                }
            }
        }
    }
}


struct AnotherCameraView_Previews: PreviewProvider {
    static var previews: some View {
        AnotherCameraView()
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        
        let currentOrientation = UIDevice.current.orientation
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        
        let view = UIView(frame: UIScreen.main.bounds)
        camera.preview.frame = UIView(frame: UIScreen.main.bounds).frame
       
        self.camera.preview.videoGravity = .resizeAspectFill
        
        updateUIForDeviceOrientation(currentOrientation, view)
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
            // Register for device orientation change notifications
            NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                // Handle device orientation change here
                let currentOrientation = UIDevice.current.orientation
                // Update the UI based on the device orientation
                updateUIForDeviceOrientation(currentOrientation, uiView)
                
                self.camera.preview.frame = UIView(frame: UIScreen.main.bounds).frame
                
            }
        }
        
    private func updateUIForDeviceOrientation(_ orientation: UIDeviceOrientation, _ uiView: UIView) {
            // Update the UI based on the device orientation
            switch orientation {
            case .portrait:
                // Handle portrait orientation
                uiView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1)
            case .landscapeLeft:
                // Handle landscape left orientation
                uiView.layer.transform = CATransform3DMakeRotation(-.pi / 2, 0, 0, 1)
            case .landscapeRight:
                // Handle landscape right orientation
                uiView.layer.transform = CATransform3DMakeRotation(.pi / 2, 0, 0, 1)
            case .portraitUpsideDown:
                // Handle landscape right orientation
                uiView.layer.transform = CATransform3DMakeRotation(.pi, 0, 0, 1)
            default:
                // Handle other orientations if needed
                break
            }
        }
}
