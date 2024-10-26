//
//  CameraView.swift
//  Banane
//
//  Created by imac luc on 21/10/2024.
//

import SwiftUI
import AVFoundation
import Vision
import Combine

/// Source: https://medium.com/@wesleymatlock/building-a-swiftui-app-for-scanning-text-using-the-camera-c4381aa5ee61
struct CameraView: UIViewControllerRepresentable {
        
    let captureSession: AVCaptureSession
    var result: (String) -> Void
        
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        let viewController = UIViewController()
        
        let videoOutput = AVCaptureVideoDataOutput() // todo: faire un service pour configurer une session
        videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        
        var parent: CameraView
        var visionRequest = [VNRequest]()
        let textSubject = PassthroughSubject<String, Never>()
        var cancellables = Set<AnyCancellable>()
                
        init(_ parent: CameraView) {
            self.parent = parent
            super.init()
            
            let textRequest = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
            textRequest.regionOfInterest = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
            textRequest.recognitionLevel = .fast
            
            textSubject
                .receive(on: RunLoop.main)
                .sink { throttledText in
                    self.parent.result(throttledText)
                }
                .store(in: &cancellables)

            self.visionRequest = [textRequest]
        }
        
        func handleDetectedText(request: VNRequest?, error: Error?) {
            
            guard let observations = request?.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            for observation in observations {
                guard let candidate = observation.topCandidates(1).first else {
                    continue
                }
                let text = candidate.string.replacingOccurrences(of: " ", with: "")
                textSubject.send(text)
            }
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            var requestOptions:[VNImageOption: Any] = [:]
            
            if let cameraData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
                requestOptions = [.cameraIntrinsics: cameraData]
            }
            
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }
            
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: requestOptions)

            try? imageRequestHandler.perform(self.visionRequest)
        }
    }
}
