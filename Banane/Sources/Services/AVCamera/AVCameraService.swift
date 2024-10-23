//
//  AVCameraService.swift
//  Banane
//
//  Created by Luc on 23/10/2024.
//

import Foundation
import AVFoundation
import Vision

final class AVCameraService: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        
    enum Failure: Error, LocalizedError {
        case unableToGetCaptureDevice
        case unableToGetDeviceInput
        case unableToGetDeviceOutput
    }
    
    func foo() throws {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
                
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            throw Failure.unableToGetCaptureDevice
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            throw Failure.unableToGetDeviceInput
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
    }
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        
        var parent: CameraView
        var visionRequest = [VNRequest]()
        var beneficiaryViewModel: BeneficiaryViewModel
                
        init(_ parent: CameraView, beneficiaryViewModel: BeneficiaryViewModel) {
            self.parent = parent
            self.beneficiaryViewModel = beneficiaryViewModel
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
                
                beneficiaryViewModel.analyse(input: text)
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
