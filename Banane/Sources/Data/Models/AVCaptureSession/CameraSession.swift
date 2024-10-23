//
//  CaptureSession.swift
//  Banane
//
//  Created by Luc on 23/10/2024.
//

import Foundation
import AVFoundation

struct CameraSession {
    let captureSession: AVCaptureSession
    let deviceInput: AVCaptureDeviceInput
    let deviceOutup: AVCaptureVideoDataOutput
}
