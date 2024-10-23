//
//  ViewController.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 17/10/2024.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIGestureRecognizerDelegate {

    let session = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    let btn = CustomButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func captureAndScanQR() {
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                session.addInput(input)
            } catch {
                print("error!")
            }
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
                print(ticketKey)
                let ticketChecker = TicketChecker()
                ticketChecker.checkETicket(ticketNumber: ticketKey) { result in
                    switch result {
                        case .success((let event, let link)):
                            print(link)
                            DispatchQueue.main.async {
                                let resultVC = ResultViewController()
                                resultVC.eventInstance = event
                                resultVC.ticketNumber = ticketKey
                                resultVC.modalPresentationStyle = .overCurrentContext
                                resultVC.modalTransitionStyle = .crossDissolve
                                self.present(resultVC, animated: true, completion: nil)
                            }
                        case .failure( let error ):
                            print(error)
                            DispatchQueue.main.async {
                                let failedVc = TicketNowFoundViewController()
                                failedVc.modalPresentationStyle = .overCurrentContext
                                failedVc.modalTransitionStyle = .crossDissolve
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
        let vc = CheckManuallViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func setup() {
        captureAndScanQR()
        addCheckManuallyButton()
        configureContainerView()
        configureInfoBoxView()
        eventListenerToCheckManuallyBtn()
    }
    
}

