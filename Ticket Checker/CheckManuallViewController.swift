//
//  CheckManuallViewController.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 21/10/2024.
//

import UIKit

class CheckManuallViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    lazy var btn: UIButton = {
        let btn = UIButton()
        btn.setTitle("X", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.layer.cornerRadius = 25
        
        // Set icon image using SF Symbols
        let icon = UIImage(systemName: "xmark") // Use the system "xmark" symbol
        btn.setImage(icon, for: .normal)
        
        return btn
    }()

}
