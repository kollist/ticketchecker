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
        
        
        let gradientLayer = CAGradientLayer()
        let innerColor = UIColor(red: 24/255, green: 81/255, blue: 197/255, alpha: 1).cgColor  // #1851C5
        let outerColor = UIColor(red: 12/255, green: 39/255, blue: 95/255, alpha: 1).cgColor  // #0C275F
        gradientLayer.colors = [innerColor, outerColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.type = .radial
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let secondVC = QRScannerViewController()
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = secondVC
            }
        }
    }
    
}
