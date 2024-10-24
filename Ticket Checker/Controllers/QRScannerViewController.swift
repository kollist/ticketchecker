//
//  ViewController.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 17/10/2024.

import UIKit
import AVFoundation
import Lottie
class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIGestureRecognizerDelegate {

    let session = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    let btn = CustomButton()
    private var isSessionRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private lazy var animationView: LottieAnimationView = {
        let animationView = LottieAnimationView()
        return animationView
    }()
    
    func addLoader() {
        animationView = .init(name: "loader")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 60),
            animationView.heightAnchor.constraint(equalToConstant: 60),
        ])
        animationView.play()
        
    }

    func removeLoader() {
        DispatchQueue.main.async {
            self.animationView.stop()
            self.animationView.removeFromSuperview()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCameraSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCameraSession()
    }
    
    private func startCameraSession() {
        if !isSessionRunning {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.session.startRunning()
                DispatchQueue.main.async {
                    self?.isSessionRunning = true
                }
            }
        }
    }
    
    private func stopCameraSession() {
        if isSessionRunning {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.session.stopRunning()
                DispatchQueue.main.async {
                    self?.isSessionRunning = false
                }
            }
        }
    }
    
    func captureAndScanQR() {
        
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                session.addInput(input)
            } catch {
                print("error!")
            }
        } else {
            print("NO CAMERA AVAILABLE")
            return
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: .main)
        output.metadataObjectTypes = [.qr]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        
        previewLayer.frame = view.frame
        
        view.layer.addSublayer(previewLayer)
        DispatchQueue.main.async {
            self.session.startRunning()
        }
    }
    
    func addOverlay(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let overlayView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view.addSubview(overlayView)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readbleObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                if let ticketKey = readbleObject.stringValue {
                    // Stop the session when presenting new view
                    stopCameraSession()
                    addLoader()
                    print(ticketKey)
                    
                    let ticketChecker = TicketChecker()
                    ticketChecker.checkETicket(ticketNumber: ticketKey) { result in
                        self.removeLoader()
                        switch result {
                            case .success((let event, let link)):
                                DispatchQueue.main.async {
                                    let resultVC = ResultViewController()
                                    resultVC.delegate = self
                                    resultVC.eventInstance = event
                                    resultVC.ticketNumber = ticketKey
                                    resultVC.modalPresentationStyle = .overCurrentContext
                                    resultVC.modalTransitionStyle = .crossDissolve
                                    self.present(resultVC, animated: true, completion: nil)
                                }
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    let failedVc = TicketNowFoundViewController()
                                    failedVc.modalPresentationStyle = .overCurrentContext
                                    failedVc.modalTransitionStyle = .crossDissolve
                                    failedVc.delegate = self
                                    self.present(failedVc, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func addCheckManuallyButton() {
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.config()
        self.view.addSubview(btn)
        self.view.bringSubviewToFront(btn)
        NSLayoutConstraint.activate([
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            btn.heightAnchor.constraint(equalToConstant: 50),
            btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    func configureContainerView() {
        let squareSize: CGFloat = 250
        let squareFrame = CGRect(
            x: (self.view.frame.width - squareSize) / 2,
            y: (self.view.frame.height - squareSize) / 2,
            width: squareSize,
            height: squareSize
        )
        
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(rect: self.view.bounds)
        let squarePath = UIBezierPath(rect: squareFrame)
        path.append(squarePath)
        
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        
        
        let dimmingView = UIView(frame: self.view.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        dimmingView.layer.mask = maskLayer
        
        self.view.addSubview(dimmingView)
        
        // Add corner borders (Top-left, Top-right, Bottom-left, Bottom-right)
        let cornerLength: CGFloat = 20
        
        // Top-left corner
        let topLeftCorner = UIView(frame: CGRect(x: squareFrame.minX, y: squareFrame.minY - 2, width: cornerLength, height: 2))
        topLeftCorner.backgroundColor = .white
        self.view.addSubview(topLeftCorner)
        
        let topLeftVertical = UIView(frame: CGRect(x: squareFrame.minX - 2, y: squareFrame.minY - 2, width: 2, height: cornerLength))
        topLeftVertical.backgroundColor = .white
        self.view.addSubview(topLeftVertical)
        
        // Top-right corner
        let topRightCorner = UIView(frame: CGRect(x: squareFrame.maxX - cornerLength , y: squareFrame.minY - 2, width: cornerLength, height: 2))
        topRightCorner.backgroundColor = .white
        self.view.addSubview(topRightCorner)
        
        let topRightVertical = UIView(frame: CGRect(x: squareFrame.maxX, y: squareFrame.minY - 2, width: 2, height: cornerLength))
        topRightVertical.backgroundColor = .white
        self.view.addSubview(topRightVertical)
        
        // Bottom-left corner
        let bottomLeftCorner = UIView(frame: CGRect(x: squareFrame.minX - 2, y: squareFrame.maxY + 2, width: cornerLength, height: 2))
        bottomLeftCorner.backgroundColor = .white
        self.view.addSubview(bottomLeftCorner)
        
        let bottomLeftVertical = UIView(frame: CGRect(x: squareFrame.minX - 2, y: squareFrame.maxY - cornerLength + 2, width: 2, height: cornerLength))
        bottomLeftVertical.backgroundColor = .white
        self.view.addSubview(bottomLeftVertical)
        
        // Bottom-right corner
        let bottomRightCorner = UIView(frame: CGRect(x: squareFrame.maxX - cornerLength + 2, y: squareFrame.maxY, width: cornerLength, height: 2))
        bottomRightCorner.backgroundColor = .white
        self.view.addSubview(bottomRightCorner)
        
        let bottomRightVertical = UIView(frame: CGRect(x: squareFrame.maxX , y: squareFrame.maxY - cornerLength, width: 2, height: cornerLength))
        bottomRightVertical.backgroundColor = .white
        self.view.addSubview(bottomRightVertical)
        
    
        self.view.bringSubviewToFront(btn)
        self.view.bringSubviewToFront(pageTitle)
    }

    
    lazy var pageTitle: UILabel = {
        let title = UILabel()
        title.numberOfLines =  0
        title.font = .systemFont(ofSize: 18, weight: .semibold)
        title.textColor = .white
        title.text = "Scan QR code"
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    func configureInfoBoxView() {

        self.view.addSubview(pageTitle)
        self.view.bringSubviewToFront(pageTitle)
        
        
        NSLayoutConstraint.activate([
            pageTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pageTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ])
    }
    
    func eventListenerToCheckManuallyBtn() {
        btn.addTarget(self, action: #selector(showCheckManulVC), for: .touchUpInside)
    }
    
    @objc func showCheckManulVC() {
        stopCameraSession()
        let vc = CheckManuallViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }

    func checkCameraPermission() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
            case .authorized:
                self.captureAndScanQR()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        print("Camera access is granted after request.")
                        self.captureAndScanQR()
                        
                    } else {
                        self.presentNoAccessVC()
                    }
                }
            case .denied, .restricted:
                self.presentNoAccessVC()
            @unknown default:
                print("Unknown case in camera permission check.")
        }
    }
    
    private func presentNoAccessVC() {
        DispatchQueue.main.async {
            let grantVC = ShowGrantPermissionViewController()
            grantVC.modalPresentationStyle = .overCurrentContext
            grantVC.modalTransitionStyle = .crossDissolve
            self.present(grantVC, animated: true, completion: nil)
        }
    }
   
    func setup() {
        checkCameraPermission()
        addCheckManuallyButton()
        configureContainerView()
        configureInfoBoxView()
        eventListenerToCheckManuallyBtn()
    }
    
}


extension QRScannerViewController: QRScannerDelegate {
    func didDismissModalView() {
        startCameraSession()
    }
}
