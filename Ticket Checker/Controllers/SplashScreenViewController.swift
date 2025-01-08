//
//  SpalshScreenViewController.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 23/10/2024.
//

import UIKit
import Lottie

class SplashScreenViewController: UIViewController {
    
    
    private lazy var animationView: LottieAnimationView = {
        let animationView = LottieAnimationView()
        return animationView
    }()
    let gradientLay = gradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView = .init(name: "splash")
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
            animationView.widthAnchor.constraint(equalToConstant: 100),
            animationView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        gradientLay.frame = view.bounds
        view.layer.insertSublayer(gradientLay, at: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.checkTokenAndNavigate()
            }
        }
        
        private func checkTokenAndNavigate() {
            UserDefaultsManager.shared.isTokenValid { result in
                switch result {
                    case .noToken:
                        self.navigateToLogin()
                    case .noSlug:
                        self.fetchAndNavigateToLocationsList()
                    case .valid:
                        self.navigateToQRScanner()
                    case .invalid:
                        self.navigateToLogin()
                }
            }
        }
    private func fetchAndNavigateToLocationsList() {
            MerchantsModal.shared.fetchLocations { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let merchants):
                        if merchants.count == 1, let slug = merchants.first?.slug {
                            UserDefaultsManager.shared.saveMerchant(slug: slug)
                            self.navigateToQRScanner()
                        } else {
                            let locationsVC = LocationsListViewController(merchants: merchants)
                            self.setRootViewController(locationsVC)
                        }
                    case .failure(let error):
                        print("Error fetching merchants: \(error.localizedDescription)")
                        self.navigateToLogin()
                    }
                }
            }
        }
        
        private func navigateToLogin() {
            DispatchQueue.main.async {
                let loginVC = LoginViewController()
                self.setRootViewController(loginVC)
            }
        }
        
        private func navigateToQRScanner() {
            DispatchQueue.main.async {
                let qrScannerVC = QRScannerViewController()
                self.setRootViewController(qrScannerVC)
            }
        }
        
        private func setRootViewController(_ viewController: UIViewController) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = viewController
                window.makeKeyAndVisible()
            }
        }
}
