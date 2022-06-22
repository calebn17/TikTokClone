//
//  CameraViewController.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/3/22.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

//MARK: - Setup
    
    //Capture Session
    var captureSession = AVCaptureSession()
    
    //Capture Device
    var videoCaptureDevice: AVCaptureDevice?
    
    //Capture Output
    var captureOutput = AVCaptureMovieFileOutput()
    
    //Capture Preview
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?

    private let cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    private let recordButton = RecordButton()
    private var previewLayer: AVPlayerLayer?
    var recordedVideoURL: URL?
    

//MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(cameraView)
        view.addSubview(recordButton)
        setupCamera()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        recordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        let size: CGFloat = 100
        recordButton.frame = CGRect(x: (view.width - size)/2, y: view.height - view.safeAreaInsets.bottom - size - 5, width: size, height: size)
    }
    
//MARK: - Configure Methods
    
    private func setupCamera() {
        
        //Add devices
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
            if let audioInput = audioInput {
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                }
            }
        }
        
        if let videoDevice = AVCaptureDevice.default(for: .video) {
            if let videoInput = try? AVCaptureDeviceInput(device: videoDevice) {
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
            }
        }
        
        //update session
        captureSession.sessionPreset = .hd1280x720
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        
        //configure preview
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds
        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }
        
        //enable camera start
        captureSession.startRunning()
    }

//MARK: - Action Methods
    
    @objc private func didTapClose() {
        navigationItem.rightBarButtonItem = nil
        recordButton.isHidden = false
        
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        }
        else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false
            tabBarController?.selectedIndex = 0
        }
    }
    
    @objc private func didTapRecord() {
        
        if captureOutput.isRecording {
            recordButton.toggle(for: .notRecording)
            //stop recording
            captureOutput.stopRecording()
        }
        else {
            recordButton.toggle(for: .recording)
            //setting the path that the videos will be saved to
            guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            url.appendPathComponent("video.mov")
            //deleting any old video that was saved at this path before
            try? FileManager.default.removeItem(at: url)
            //after the path is cleared, let's start recording
            captureOutput.startRecording(to: url, recordingDelegate: self)
        }
    }
    
    @objc private func didTapNext() {
        //push caption controller
        guard let recordedVideoURL = recordedVideoURL else {return}
        let vc = CaptionViewController(videoURL: recordedVideoURL)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - AVCaptureFileOutputRecordingDelegate Methods

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when recording your video", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        print("finish recording to url: \(outputFileURL.absoluteString)")
        
        recordedVideoURL = outputFileURL
        
        if UserDefaults.standard.bool(forKey: "save_video") {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))
        
        let player = AVPlayer(url: outputFileURL)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        
        guard let previewLayer = previewLayer else {return}
        recordButton.isHidden = true
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.player?.play()
    }
}
