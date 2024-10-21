//
//  EventDataDetailsViws.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 21/10/2024.
//

import UIKit

class EventDataDetailsView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        configureSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configureSubviews()
    }
    
    private lazy var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView();
        backgroundImage.image = UIImage(named: "EventDetailsBg")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.clipsToBounds = true
        return backgroundImage
    }()
    
    
    private func configureSubviews() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImage.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        self.sendSubviewToBack(backgroundImage)
    }
}

