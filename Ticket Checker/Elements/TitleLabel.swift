//
//  EventTitle.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 21/10/2024.
//

import UIKit

class TitleLabel: UILabel {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureLabel()
    }
    
    private func configureLabel() {
        self.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        self.textColor = .label
        self.translatesAutoresizingMaskIntoConstraints = false 
    }
    
    func config(_ eventTitle: String) {
        self.text = eventTitle
    }
}
