//
//  RequestSentLoaderViewController.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 23/10/2024.
//

import UIKit
import Lottie

class RequestSentLoaderViewController: UIViewController {

    private var animationView: LottieAnimationView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        animationView = .init(name: "splash")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView!.play()
    }
    
    

}
