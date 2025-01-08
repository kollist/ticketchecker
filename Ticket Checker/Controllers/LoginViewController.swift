//
//  LoginViewController.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 31/10/2024.
//

import UIKit
import SwiftEmailValidator
import RecaptchaEnterprise

class LoginViewController: UIViewController {
    var recaptchaClient: RecaptchaClient?
    let gradientLay = gradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupViews()
        runAnimation()
    }
    func runAnimation() {
        self.loginButton.transform = CGAffineTransform(translationX: 0, y: 200) // Start button off-screen below
        self.loginButton.alpha = 0 // Start button invisible
        
        self.addCurvedBottom(to: self.animatedView)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear], animations: {
            self.animatedView.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height * 0.7)
        }) {_ in
            self.logoImageView.isHidden = false
            self.animateLoginButton()
        }
    }
    
    private func animateLoginButton() {
        self.loginButton.isHidden = false
        
        UIView.animate(withDuration: 0.75, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            self.loginButton.transform = .identity
            self.loginButton.alpha = 1
        })
    }
    
    @objc func login() {
        Task {
            await login(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        }
    }
    
    private func login(email: String, password: String) async {
        if (email == "") {
            showErrorAlert("Email cannot be empty")
        }
        if (password == "") {
            showErrorAlert("Password cannot be empty")
        }
        if (!isEmailValid(email)) {
            showErrorAlert("The email is not valid")
            return
        }
        if (!isPasswordValid(password)) {
            showErrorAlert("Password format is not valid")
        }
        guard let gtoken = await getCaptchaToken() else {
            showErrorAlert("Captcha verification failed.")
            return
        }
        
        LoginModal.shared.login(email: email, password: password, gtoken: gtoken, rememberMe: true) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let profile):
                    self.handleSuccessfulLogin(with: profile)
                case .failure(let error):
                    self.handleLoginFailure(with: error)
                }
            }
        }
    }
    // Helper methods
    private func handleSuccessfulLogin(with profile: Profile) {
        let merchants = profile.user?.groupMerchants.compactMap { $0 } ?? []
        
        if merchants.isEmpty {
            self.navigateToEmptyStateView()
        } else if merchants.count == 1, let slug = merchants.first?.slug {
            UserDefaultsManager.shared.saveMerchant(slug: slug)
            self.navigateToQRScanner()
        } else {
            self.navigateToLocationsList(with: merchants)
        }
    }
    
    private func handleLoginFailure(with error: ErrorResponse) {
        showErrorAlert(error.error)
    }
    
    private func navigateToEmptyStateView() {
        let emptyStateVC = QRScannerViewController()
        self.setRootViewController(emptyStateVC)
    }
    
    private func navigateToQRScanner() {
        let qrScannerVC = QRScannerViewController()
        self.setRootViewController(qrScannerVC)
    }
    
    private func navigateToLocationsList(with merchants: [Merchant]) {
        let locationsListVC = LocationsListViewController(merchants: merchants)
        self.setRootViewController(locationsListVC)
    }
    
    private func setRootViewController(_ viewController: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }
    
    // Email Input Field
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .done
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = CustomButton()
        button.config("Login")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Welcome to Zaytech Scanner"
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.text = "Please enter your credentials to login"
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private func setupViews() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(logoImageView)
        view.addSubview(animatedView)
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 45),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            emailTextField.widthAnchor.constraint(equalToConstant: 300),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            loginButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginButton.trailingAnchor, multiplier: 2),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            animatedView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            animatedView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            animatedView.topAnchor.constraint(equalTo: self.view.topAnchor),
            animatedView.heightAnchor.constraint(equalTo: self.view.heightAnchor),

            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.25),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    
    func addCurvedBottom(to view: UIView) {
        let path = UIBezierPath()
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height - 20))
        path.addQuadCurve(to: CGPoint(x: 0, y: height - 20), controlPoint: CGPoint(x: width / 2, y: height + 20))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.blue.cgColor
        
        view.layer.mask = shapeLayer
    }
    
    lazy var logoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: "Scanner")
        imgView.image = img
        imgView.isHidden = true
        imgView.layer.borderWidth = 3
        imgView.layer.cornerRadius = 40
        imgView.layer.borderColor = UIColor.white.cgColor
        return imgView
    }()
    lazy var animatedView: UIView = {
        let view = UIView()
        gradientLay.frame = self.view.bounds
        view.layer.insertSublayer(gradientLay, at: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Validate email format using SwiftEmailValidator
    func isEmailValid(_ email: String) -> Bool {
        return EmailSyntaxValidator.correctlyFormatted(email.lowercased())
    }
    func isPasswordValid(_ password: String) -> Bool {
        if password.count < 6 {
            return false
        }
        return true
    }
    
    func getCaptchaToken() async -> String? {
        do {
            if let key_id = Bundle.main.object(forInfoDictionaryKey: "KEY_ID") as? String {
                self.recaptchaClient = try await Recaptcha.fetchClient(withSiteKey: key_id)
                if let recaptchaClient = recaptchaClient {
                    let token = try await recaptchaClient.execute(withAction: .login)
                    return token
                }
            }
        } catch let error as RecaptchaError {
            showErrorAlert("RecaptchaClient creation error: \(String(describing: error.errorMessage)).")
        } catch {
            showErrorAlert("Something went wrong: \(String(describing: error)).")
        }
        return nil
    }
    func showErrorAlert(_ message: String) {
        let errorAlert = ErrorAlertViewController(message: message)
        present(errorAlert, animated: true)
    }
    func showErrorLabel( _ txtField: UITextField? = nil) {
        errorLabel.removeFromSuperview()
        guard let textField = txtField else {
            return
        }
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 3),
            errorLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor)
        ])
        
    }
    
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            if let input = textField.text {
                if textField == emailTextField {
                    if (!isEmailValid(input)) {
                        errorLabel.text = "The email is not valid"
                        showErrorLabel(textField)
                    }
                }
                if textField == passwordTextField {
                    if (!isPasswordValid(input)) {
                        errorLabel.text = "Password should be minimum 6 characters"
                        showErrorLabel(textField)
                    }
                }
            }
        }else {
            showErrorLabel()
        }
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        showErrorLabel()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
}
