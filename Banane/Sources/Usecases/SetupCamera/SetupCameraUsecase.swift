//
//  SetupCameraUsecase.swift
//  Banane
//
//  Created by Luc on 23/10/2024.
//
//  Template: 7.0

import Foundation
import AVFoundation

protocol SetupCameraUsecaseProtocol: Sendable {
    func execute(input: SetupCameraUsecase.Input) throws -> SetupCameraUsecase.Result
 }

/// Set a valid CaptureSession
final class SetupCameraUsecase: SetupCameraUsecaseProtocol {
    
    // MARK: - DTO

    struct Input {

    }

    struct Result {
        let validCaptureSession: CameraSession
    }
    
    // MARK: - Failure
    
    enum Failure: Error {
        case unableToSetupCaptureDevice
        case unableToSetupDeviceInput
    }
    
    // MARK: - DataTask
    
    @discardableResult
    func execute(input: SetupCameraUsecase.Input) throws -> SetupCameraUsecase.Result {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
                
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            throw Failure.unableToSetupCaptureDevice
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            throw Failure.unableToSetupDeviceInput
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        return .init(validCaptureSession: .init(captureSession: captureSession,
                                                deviceInput: videoInput,
                                                deviceOutup: videoOutput))
    }
}
