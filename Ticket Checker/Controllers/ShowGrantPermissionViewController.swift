//
//  ShowGrantPermissionViewController.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 23/10/2024.
//

import UIKit

class ShowGrantPermissionViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    var bottomConstraint: NSLayoutConstraint?
    var centerYConstraint: NSLayoutConstraint?
    var keyboardVisible: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black.withAlphaComponent(0.4)

        self.view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(nextButton)
        setupConstraints()
        
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor(named: "PopUpBg")
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        lbl.text = "We need access to your camera to scan QR codes. Please enable camera access in your device settings."
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.isUserInteractionEnabled = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    lazy var nextButton: UIButton = {
        let btn = CustomButton()
        btn.config("Go To Settings!")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(goToAccess), for: .touchUpInside)
        return btn
    }()
    
    @objc func goToAccess() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings)
        }
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),



            nextButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            nextButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            
            
        ])
    }
    

    @objc private func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
}

