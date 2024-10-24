//
//  TicketNowFoundViewController.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 21/10/2024.
//

import UIKit

class TicketNowFoundViewController: UIViewController, UIGestureRecognizerDelegate {

    weak var delegate: QRScannerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func configTryAgainBtn() {
        let btn = CustomButton()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBackToScan))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        btn.addGestureRecognizer(tapGesture)
        btn.config("Try Again")
        btn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btn)
        NSLayoutConstraint.activate([
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            btn.heightAnchor.constraint(equalToConstant: 50),
            btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    @objc func goBackToScan() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.didDismissModalView()
    }
    
    private func configNotFoundIconViewAndTitleAndDesc() {
        let eventView = EventView()
        eventView.backgroundColor = UIColor(named: "InfoBgColor") ?? .cyan
        eventView.layer.cornerRadius = 209 / 2
        eventView.layer.masksToBounds = true
        
        let imgView = UIImageView()
        imgView.image = UIImage(named: "NotFoundTicketIcon")
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        
        let title = TitleLabel()
        title.config("Ticket Not Found")
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let lbl = UILabel()
        lbl.text = "Unfortunately, we couldn't find any tickets matching this QR code. Please double-check the code or try again later."
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .light)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .gray
        
        eventView.addSubview(imgView)
        
        self.view.addSubview(eventView)
        self.view.addSubview(title)
        self.view.addSubview(lbl)
        
        NSLayoutConstraint.activate([
            eventView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            eventView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40),
            eventView.heightAnchor.constraint(equalToConstant: 209),
            eventView.widthAnchor.constraint(equalToConstant: 209),
            
            imgView.centerXAnchor.constraint(equalTo: eventView.centerXAnchor),
            imgView.centerYAnchor.constraint(equalTo: eventView.centerYAnchor, constant: 40),
            
            title.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            title.topAnchor.constraint(equalTo: eventView.bottomAnchor, constant: 22),
            
            lbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            lbl.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            lbl.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10)
        ])
    }
    

    
    private func configureView() {
        self.view.backgroundColor = UIColor(named: "BgColor")
    }
    
    private func config() {
        configureView()
        configNotFoundIconViewAndTitleAndDesc()
        configTryAgainBtn()
    }
    

}
