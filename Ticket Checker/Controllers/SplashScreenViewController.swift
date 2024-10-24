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
            animationView.widthAnchor.constraint(equalToConstant: 150),
            animationView.heightAnchor.constraint(equalToConstant: 250),
        ])
        
        
        let gradientLayer = CAGradientLayer()

        // Define your colors for the gradient
        let innerColor = UIColor(red: 24/255, green: 81/255, blue: 197/255, alpha: 1).cgColor  // #1851C5
        let outerColor = UIColor(red: 12/255, green: 39/255, blue: 95/255, alpha: 1).cgColor  // #0C275F
        
        // Set the colors and locations for the gradient
        gradientLayer.colors = [innerColor, outerColor]
        gradientLayer.locations = [0.0, 1.0]
        
        // Set the start and end points to simulate a radial gradient (centered)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        // Set the type to radial by transforming the shape
        gradientLayer.type = .radial
        
        // Apply the gradient to fill the entire view
        gradientLayer.frame = view.bounds
        
        // Insert the gradient as the background of the view
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let secondVC = QRScannerViewController()
            guard let window = UIApplication.shared.windows.first else { return }
            window.rootViewController = secondVC
        }
    }
    
}
