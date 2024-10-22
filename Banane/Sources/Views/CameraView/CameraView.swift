//
//  CréditCardOCR.swift
//  ocr-POC
//
//  Created by imac luc on 21/10/2024.
//

import SwiftUI
import AVFoundation
import Vision

/// Source: https://medium.com/@wesleymatlock/building-a-swiftui-app-for-scanning-text-using-the-camera-c4381aa5ee61
struct CameraView: UIViewControllerRepresentable {
    
    @EnvironmentObject var scannerIBANViewModel: ScannerViewModel
        
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, scannerViewModel: scannerIBANViewModel)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
                
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { 
            return viewController
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { 
            return viewController
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        
        var parent: CameraView
        var visionRequest = [VNRequest]()
        var scannerViewModel: ScannerViewModel
                
        init(_ parent: CameraView, scannerViewModel: ScannerViewModel) {
            self.parent = parent
            self.scannerViewModel = scannerViewModel
            super.init()
            
            let textRequest = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
            textRequest.regionOfInterest = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
            textRequest.recognitionLevel = .fast

            self.visionRequest = [textRequest]
        }
        
        func handleDetectedText(request: VNRequest?, error: Error?) {
            
            guard let observations = request?.results as? [VNRecognizedTextObservation] else {
                return
            }
                        
            for observation in observations {
                guard let candidate = observation.topCandidates(1).first else { continue }
                let text = candidate.string.replacingOccurrences(of: " ", with: "")
                
                scannerViewModel.analyse(input: text)
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
