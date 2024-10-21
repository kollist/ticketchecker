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
        previewLayer.videoGravity = .resizeAspectFill
        let width = view.bounds.width * 0.75
        let squareSize = min(width, width)
        
        let xPos = (view.bounds.width - squareSize) / 2
        let yPos = (view.bounds.height - squareSize) / 2
        
        previewLayer.frame = CGRect(x: xPos, y: yPos, width: width, height: width)
        
        view.layer.addSublayer(previewLayer)
        DispatchQueue.main.async {
            self.session.startRunning()
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
            if let ticketKey = readbleObject.stringValue {
                print(ticketKey)
                let ticketChecker = TicketChecker()
                ticketChecker.checkETicket(ticketNumber: ticketKey) { result in
                    switch result {
                    case .success(let event):
                        DispatchQueue.main.async {
                            let resultVC = ResultViewController()
                            resultVC.eventInstance = event
                            
                            self.present(resultVC, animated: true, completion: nil)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            let failedVc = TicketNowFoundViewController()
                            failedVc.modalPresentationStyle = .overCurrentContext
//                            failedVc.modalTransitionStyle = .crossDissolve
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
        let squareView = EventView()
        squareView.translatesAutoresizingMaskIntoConstraints = false
        
        squareView.layer.borderColor = UIColor(named: "ButtonColor")?.cgColor
        squareView.layer.borderWidth = 5
        
        self.view.addSubview(squareView)
        self.view.bringSubviewToFront(squareView)
        NSLayoutConstraint.activate([
            squareView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            squareView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            squareView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            squareView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8)
        ])
    }
    func configureInfoBoxView() {
        let infoView = UIView()
        infoView.backgroundColor = UIColor(named: "InfoBgColor") ?? .systemBlue
        infoView.layer.cornerRadius = 20
        infoView.translatesAutoresizingMaskIntoConstraints = false
        
        let title = TitleLabel()
        title.config("Scan QR code")
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let description = UILabel()
        description.text = "Easily place the QR code within the frame for seamless scanning and instant access to tickets, information, and more."
        description.textColor = .gray
        description.textAlignment = .center
        description.font = .systemFont(ofSize: 12, weight: .light)
        description.translatesAutoresizingMaskIntoConstraints = false
        description.numberOfLines = 0
        description.textAlignment = .center
        description.lineBreakMode = .byWordWrapping
        
        
        infoView.addSubview(title)
        infoView.addSubview(description)
        
        self.view.addSubview(infoView)
        self.view.bringSubviewToFront(infoView)
        
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 20),
            title.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            
            description.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            description.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -20),
            description.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            description.widthAnchor.constraint(equalTo: infoView.widthAnchor, multiplier: 0.95),
            
            infoView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            infoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            infoView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            infoView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func setup() {
        self.view.backgroundColor = .white
        captureAndScanQR()
        addCheckManuallyButton()
        configureContainerView()
        configureInfoBoxView()
    }
    
}

