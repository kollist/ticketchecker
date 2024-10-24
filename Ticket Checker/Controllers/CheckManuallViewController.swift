//
//  CheckManuallViewController.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 21/10/2024.
//

import UIKit
import Lottie

class CheckManuallViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {

    var bottomConstraint: NSLayoutConstraint?
    var centerYConstraint: NSLayoutConstraint?
    var keyboardVisible: Bool = false
    weak var delegate: QRScannerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black.withAlphaComponent(0.4)
        ticketNumberInput.delegate = self
        self.view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(ticketNumberInput)
        containerView.addSubview(nextButton)
        containerView.addSubview(errLbl)
        containerView.addSubview(titleCloseBtnContainer)
        containerView.addSubview(closeButton)
        containerView.bringSubviewToFront(closeButton)
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didDismissModalView()
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
        animationView.play()
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            animationView.widthAnchor.constraint(equalToConstant: 300),
            animationView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }

    func removeLoader() {
        DispatchQueue.main.async {
            self.animationView.stop()
            self.animationView.removeFromSuperview()
        }
    }
    
    @objc func dismissKeyboard() {
        if keyboardVisible == true {
            view.endEditing(true)
        } else {
            self.dismiss(animated: true)
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == containerView || touch.view?.isDescendant(of: containerView) == true ? false : true;
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardVisible = true
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        centerYConstraint?.isActive = false
        bottomConstraint?.isActive = false

        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardSize.height - 20)
        bottomConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardVisible = false
        bottomConstraint?.isActive = false
        bottomConstraint = nil

        centerYConstraint?.isActive = true

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func adjustContainerViewForKeyboard(isShowing: Bool, keyboardHeight: CGFloat = 0) {
        
        if isShowing {
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = false
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight - 20).isActive = true
        } else {
            containerView.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "ClosePopUpIcon"), for: .normal)
        btn.isUserInteractionEnabled = true
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        return btn
    }()
    
    
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
        lbl.text = "Trouble scanning? Enter manually"
        lbl.textAlignment = .left
        lbl.isUserInteractionEnabled = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    
    lazy var ticketNumberInput: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Ticket Number"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "InputFieldBg")
        textField.layer.borderColor = UIColor(named: "InputFieldBorders")?.cgColor
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var nextButton: UIButton = {
        let btn = CustomButton()
        btn.config("Next")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(checkETicket), for: .touchUpInside)
        return btn
    }()
    
    lazy var errLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .red
        lbl.font = .systemFont(ofSize: 10)
        lbl.text = "Please enter a ticket ID"
        lbl.isHidden = true
        return lbl
    }()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errLbl.isHidden = true
        return true
    }
    
    @objc func checkETicket() {
        guard let ticketKey = ticketNumberInput.text, !ticketKey.isEmpty else {
            errLbl.isHidden = false
            return
        }
        errLbl.isHidden = true
        view.endEditing(true)
        let ticketChecker = TicketChecker()
        addLoader()
        ticketChecker.checkETicket(ticketNumber: ticketKey) { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.removeLoader()
            }
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
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if (textField.text != "") {
//            errLbl.isHidden = true
            return true
//        }
//        errLbl.isHidden = false
//        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errLbl.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    private func setupConstraints() {
        
        centerYConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            
            centerYConstraint ?? containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalToConstant: 215),
            
            titleCloseBtnContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleCloseBtnContainer.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            titleCloseBtnContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),


            ticketNumberInput.topAnchor.constraint(equalTo: titleCloseBtnContainer.bottomAnchor, constant: 40),
            ticketNumberInput.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            ticketNumberInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ticketNumberInput.heightAnchor.constraint(equalToConstant: 50),
            
            errLbl.topAnchor.constraint(equalTo: ticketNumberInput.bottomAnchor, constant: 5),
            errLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errLbl.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            

            nextButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            nextButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            
        ])
    }
    
    lazy var titleCloseBtnContainer: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        return view
    }()

    @objc private func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
}

