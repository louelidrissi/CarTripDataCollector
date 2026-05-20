//
//  VideoManager.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/10/26.
//
import AVFoundation

final class VideoManager: NSObject, AVCaptureFileOutputRecordingDelegate {
    
    private let session = AVCaptureSession()
    private let movieOutput = AVCaptureMovieFileOutput()
    
    private var currentSessionId: UUID?
    private var sessionStartTime: Date?
    
    private var outputURL: URL?
    
    override init() {
        super.init()
        configureSession()
    }
    
    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .high
        
        guard let camera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front
        ) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            if session.canAddOutput(movieOutput) {
                session.addOutput(movieOutput)
            }
            
        } catch {
            print("Camera setup error: \(error)")
        }
        
        session.commitConfiguration()
    }
    func startRecording(sessionId: UUID, startTime: Date) {

        // store session metadata (THIS is key for alignment)
        self.currentSessionId = sessionId
        self.sessionStartTime = startTime

        // start camera session
        if !session.isRunning {
            session.startRunning()
        }

        // file path
        let fileName = "\(sessionId.uuidString).mov"

        let documents = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        let url = documents.appendingPathComponent(fileName)

        outputURL = url

        movieOutput.startRecording(to: url, recordingDelegate: self)

        print("🎥 Recording started for session:", sessionId)
    }
    
    func stopRecording() {
        if movieOutput.isRecording {
            movieOutput.stopRecording()
        }

        if session.isRunning {
            session.stopRunning()
        }

        print("🎥 Recording stopped")
    }
    
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {

        if let error = error {
            print("Video error:", error)
        } else {
            print("Video saved:", outputFileURL)
        }
    }
}
