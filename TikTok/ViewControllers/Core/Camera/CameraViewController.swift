//
//  CameraViewController.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import UIKit
import SnapKit
import AVFoundation

class CameraViewController: UIViewController {
    //MARK: - Properties
    private lazy var captureSession = AVCaptureSession()
    private var videoCaptureDevice: AVCaptureDevice?
    private lazy var captureOutput = AVCaptureMovieFileOutput()
    private var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    private var previewLayer: AVPlayerLayer?
    private var recordedVideoURL: URL?
    
    private lazy var cameraView = UIView()
    private lazy var recordButton = RecordButton()
    
    //MARK: - Initializers
    
    //MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        
        setupViews()
        addSubViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpLayout()
    }
    
    //MARK: - Setup Views Methods
    private func setupCameraView() {
        cameraView.clipsToBounds = true
        cameraView.backgroundColor = .black
    }
    
    private func setUpCamera() {
        // Add devices
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            if let audioInput = try? AVCaptureDeviceInput(device: audioDevice) {
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
        
        // Update session
        captureSession.sessionPreset = .hd1280x720
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        
        // Configure preview
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds
        if let captureLayer = capturePreviewLayer {
            cameraView.layer.addSublayer(captureLayer)
        }
        
        // Enable camera start
        let backgroundThread = DispatchQueue(label: "captureSessionBackgroundThread", qos: .background)
        backgroundThread.async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
        
    //MARK: - Setting Views
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        setupCameraView()
        setUpCamera()
        recordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
    }
    
    //MARK: - Setting
    private func addSubViews() {
        view.addSubview(cameraView)
        view.addSubview(recordButton)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        cameraView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        recordButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.width.height.equalTo(80)
        }
    }
    
    //MARK: - Actions
    @objc private func didTapClose() {
        navigationItem.rightBarButtonItem = nil
        recordButton.isHidden = false
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        } else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false
            tabBarController?.selectedIndex = 0
        }
    }
    
    @objc private func didTapRecord() {
        if captureOutput.isRecording {
            // stop recording
            recordButton.toggle(for: .notRecording)
            captureOutput.stopRecording()
            HapticsManager.shared.vibrateForSelection()
        } else {
            // start recording
            guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            
            HapticsManager.shared.vibrateForSelection()

            url.appendPathComponent("video.mov", conformingTo: .quickTimeMovie)
            
            recordButton.toggle(for: .recording)
            
            try? FileManager.default.removeItem(at: url)
            
            captureOutput.startRecording(to: url, recordingDelegate: self)
        }
    }
}

//MARK: - Extensions
extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        guard error == nil else {
            let alert = UIAlertController(title: "Woops", message: "Something went wrong when recording your video", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        print("Finished recording to url: \(outputFileURL.absoluteString)")
        
        recordedVideoURL = outputFileURL
        
        if UserDefaults.standard.bool(forKey: "save_video") {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))
        
        let player = AVPlayer(url: outputFileURL)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        guard let previewLayer = previewLayer else {
            return
        }
        recordButton.isHidden = true
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.player?.play()
    }
    
    //MARK: - Actions
    @objc private func didTapNext() {
        // Push caption controller
        guard let url = recordedVideoURL else {
            return
        }
        
        HapticsManager.shared.vibrateForSelection()

        let vc = CaptionViewController(videoURL: url)
        navigationController?.pushViewController(vc, animated: true)
    }
}
