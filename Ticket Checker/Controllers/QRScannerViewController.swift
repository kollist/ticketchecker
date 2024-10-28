//
//  ViewController.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 17/10/2024.

import UIKit
import AVFoundation
import Lottie
import Network

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIGestureRecognizerDelegate {

    private var monitor: NWPathMonitor?
    private var isConnectedToInternet: Bool = false
    var captureDevice: AVCaptureDevice?
    let session = AVCaptureSession()
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer()
        layer.frame = view.bounds
        return layer
    }()
    private var isSessionRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Set up the long press gesture
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        view.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            toggleFlash(on: true)
        case .ended, .cancelled, .failed:
            toggleFlash(on: false)
        default:
            break
        }
    }
    func toggleFlash(on: Bool) {
        guard let device = captureDevice, device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Flash could not be used")
        }
    }

    lazy var checkManuallyButton: CustomButton = {
        let btn = CustomButton()
        btn.config()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(showCheckManulVC), for: .touchUpInside)
        return btn
    }()
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
        loaderContainer.addSubview(animationView)
        
        view.addSubview(loaderContainer)
        NSLayoutConstraint.activate([
            
            loaderContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loaderContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
            loaderContainer.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: loaderContainer.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: loaderContainer.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 60),
            animationView.heightAnchor.constraint(equalToConstant: 60),
        ])
        animationView.play()
        
    }
    lazy var loaderContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    func removeLoader() {
        DispatchQueue.main.async {
            self.animationView.stop()
            self.loaderContainer.removeFromSuperview()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCameraSession()
        startNetworkMonitor {  isConnected in
            if !isConnected {
                self.showNoInternetAlert()
            }
        }

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCameraSession()
        monitor?.cancel()
    }
    private func startCameraSession() {
        if !isSessionRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
                DispatchQueue.main.async {
                    self.isSessionRunning = true
                }
            }
        }
    }
    
    private func stopCameraSession() {
        if isSessionRunning {
            DispatchQueue.global(qos: .userInitiated).async { 
                self.session.stopRunning()
                DispatchQueue.main.async {
                    self.isSessionRunning = false
                }
            }
        }
    }
    
    func captureAndScanQR() {
        DispatchQueue.main.async {
            if self.view.subviews.contains(self.goToSettingsButton) {
                self.checkManuallyButton.removeFromSuperview()
                self.goToSettingsButton.removeFromSuperview()
                self.view.addSubview(self.checkManuallyButton)
                
                NSLayoutConstraint.activate([
                    self.checkManuallyButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
                    self.checkManuallyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
                    self.checkManuallyButton.heightAnchor.constraint(equalToConstant: 50),
                    self.checkManuallyButton.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
                ])
            }
        }
        
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            self.captureDevice = captureDevice
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
        
        previewLayer.session = session
        previewLayer.videoGravity = .resizeAspectFill
        
        
        DispatchQueue.global(qos: .background).async {
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
                    stopCameraSession()
                    addLoader()
                    
                    let ticketChecker = TicketChecker()

                    let timeout: TimeInterval = 8
                    let timeoutHandler = DispatchWorkItem {
                        self.removeLoader()
                        ticketChecker.cancelCurrentRequest()
                        let alert = UIAlertController(title: "Error", message: "Request timed out. Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self.startCameraSession()
                        }))
                        self.present(alert, animated: true)
                        return
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: timeoutHandler)
                    ticketChecker.checkETicket(ticketNumber: ticketKey.trimmingCharacters(in: .whitespacesAndNewlines)) { result in
                        timeoutHandler.cancel()
                        self.removeLoader()
                        switch result {
                            case .success((let event, _ )):
                                DispatchQueue.main.async {
                                    let resultVC = ResultViewController()
                                    resultVC.eventInstance = event
                                    resultVC.ticketNumber = ticketKey.trimmingCharacters(in: .whitespacesAndNewlines)
                                    self.navigationController?.pushViewController(resultVC, animated: true)
                                }
                            case .failure(let error):
                                print(error)
                                DispatchQueue.main.async {
                                    let newViewController = ResultViewController()
                                    newViewController.notFound = true
                                    self.navigationController?.pushViewController(newViewController, animated: true)
                        }
                    }
                }
            }
        }
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
        
        let frames = [
            CGRect(x: squareFrame.minX, y: squareFrame.minY - 2, width: cornerLength, height: 2),
            CGRect(x: squareFrame.minX - 2, y: squareFrame.minY - 2, width: 2, height: cornerLength),
            CGRect(x: squareFrame.maxX - cornerLength , y: squareFrame.minY - 2, width: cornerLength, height: 2),
            CGRect(x: squareFrame.maxX, y: squareFrame.minY - 2, width: 2, height: cornerLength),
            CGRect(x: squareFrame.minX - 2, y: squareFrame.maxY + 2, width: cornerLength, height: 2),
            CGRect(x: squareFrame.minX - 2, y: squareFrame.maxY - cornerLength + 2, width: 2, height: cornerLength),
            CGRect(x: squareFrame.maxX - cornerLength + 2, y: squareFrame.maxY, width: cornerLength, height: 2),
            CGRect(x: squareFrame.maxX , y: squareFrame.maxY - cornerLength, width: 2, height: cornerLength)
        ]
        
        for frame in frames {
            let view = UIView(frame: frame)
            view.backgroundColor = .white
            self.view.addSubview(view)
        }
        
        self.view.bringSubviewToFront(checkManuallyButton)
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
    
    
    @objc func showCheckManulVC() {
        stopCameraSession()
        let viewControllerToPresent = CheckManuallViewController()
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        viewControllerToPresent.delegate = self
        navigationController.modalPresentationStyle = .overCurrentContext
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.setNavigationBarHidden(true, animated: false)
        present(navigationController, animated: true, completion: nil)
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
            let alert = UIAlertController(
                title: "Camera Access Denied",
                message: "Please enable camera access in settings to continue.",
                preferredStyle: .alert
            )
            
            let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
                if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            
                self.present(alert, animated: true)
        
            self.checkManuallyButton.removeFromSuperview()
            self.view.addSubview(self.checkManuallyButton)
            self.view.addSubview(self.goToSettingsButton)
            
            NSLayoutConstraint.activate([
                self.checkManuallyButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
                self.checkManuallyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
                self.checkManuallyButton.heightAnchor.constraint(equalToConstant: 50),
                self.checkManuallyButton.bottomAnchor.constraint(equalTo: self.goToSettingsButton.topAnchor, constant: -15),
                
                self.goToSettingsButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
                self.goToSettingsButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
                self.goToSettingsButton.heightAnchor.constraint(equalToConstant: 50),
                self.goToSettingsButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
            ])
        }
    }

    @objc func goToSetting() {
        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
        }
    }

    lazy var goToSettingsButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 25
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        btn.backgroundColor = .systemBackground.withAlphaComponent(0)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(goToSetting), for: .touchUpInside)
        btn.setTitle("Camera Permission", for: .normal)
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    private func startNetworkMonitor(completion: @escaping (Bool) -> Void) {
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        
        monitor?.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            DispatchQueue.main.async {
                self?.isConnectedToInternet = isConnected
                completion(isConnected)
                
                if !isConnected {
                    self?.showNoInternetAlert()
                }
            }
        }
        
        monitor?.start(queue: queue)
    }

    private func showNoInternetAlert() {
        if self.presentedViewController is UIAlertController {
            return
        }
        
        self.isSessionRunning = false
        stopCameraSession()
        
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your internet connection and try again.",
            preferredStyle: .alert
        )
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            self.startNetworkMonitor { isConnected in
                if isConnected {
                    self.startCameraSession()
                } else {
                    self.showNoInternetAlert()
                }
            }
        }
        
        alert.addAction(retryAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    func setup() {
        view.layer.addSublayer(previewLayer)
        self.view.addSubview(checkManuallyButton)
        self.view.bringSubviewToFront(checkManuallyButton)
        self.view.addSubview(pageTitle)
        self.view.bringSubviewToFront(pageTitle)
        
        NSLayoutConstraint.activate([
            checkManuallyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            checkManuallyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            checkManuallyButton.heightAnchor.constraint(equalToConstant: 50),
            checkManuallyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            
            pageTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pageTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ])
        checkCameraPermission()
        configureContainerView()
        startNetworkMonitor {  isConnected in
            if !isConnected {
                self.showNoInternetAlert()
            }
        }
    }
    
}

extension QRScannerViewController: QRScannerDelegate {
    func didDismissModalView() {
        startCameraSession()
        removeLoader()
    }
}
