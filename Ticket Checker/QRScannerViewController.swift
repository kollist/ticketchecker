//
//  ViewController.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 17/10/2024.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

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
        
        // Calculate square dimensions based on the smaller of the view's width or height
        let squareSize = min(view.bounds.width * 0.8, view.bounds.height * 0.4)
        
        // Set the frame to center the square preview layer on the screen
        let xPos = (view.bounds.width - squareSize) / 2
        let yPos = (view.bounds.height - squareSize) / 2
        
        previewLayer.frame = CGRect(x: xPos, y: yPos, width: squareSize, height: squareSize)
        
        view.layer.addSublayer(previewLayer)
        DispatchQueue.main.async {
            self.session.startRunning()
            self.view.bringSubviewToFront(self.btn)
        }
    }
    func addOverlay(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let overlayView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6) // Set your desired color and transparency
        self.view.addSubview(overlayView)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readbleObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            print("readableObject :: \(readbleObject.stringValue!)")
            session.startRunning()
        }
    }
    
    func addCheckManuallyButton() {
        btn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btn)
        NSLayoutConstraint.activate([
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            btn.heightAnchor.constraint(equalToConstant: 50),
            btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        self.view.bringSubviewToFront(btn)
    }
    
    func setupTheVideoLayerPreview() {}
    func setupPreviewLayerContainer() {}
    func setup() {
        self.view.backgroundColor = .white
        captureAndScanQR()
        addCheckManuallyButton()
    }
    
}

