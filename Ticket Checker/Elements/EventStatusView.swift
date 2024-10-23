//
//  StatusView.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 20/10/2024.
//

import UIKit

class EventStatusView: UIView {

    var alreadyCheckedTitle: String = "TICKET ALREADY SCANNED."
    var validTicketTitle: String = "TICKET VALID"
    override func layoutSubviews() {
        super.layoutSubviews()
        updateMaskAndGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func updateMaskAndGradient() {
        // Update mask path
        let maskLayer = CAShapeLayer()
        maskLayer.path = createCurvedPath(self).cgPath
        self.layer.mask = maskLayer

        // Update gradient frame
        if let gradientLayer = self.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
        }
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 0 // Reset corner radius

        // Create a custom path to clip the bottom corners with a curve
        let maskLayer = CAShapeLayer()
        maskLayer.path = createCurvedPath(self).cgPath
        self.layer.mask = maskLayer
    }
    
    private lazy var iconImage: UIImageView = {
        var img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
        
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private func configureSubviews() {
        setupView()
        
        addSubview(iconImage)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 40),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configureSubviews()
    }
    
    func config(checked: Bool) {
        if checked {
            let title = "Ticket"
            if let img = UIImage(named: "InvalidTicketIcon"), let dark = UIColor(named: "InvalidTicketColorTwo")?.cgColor, let light = UIColor(named: "InvalidTicketColorOne")?.cgColor {
                iconImage.image = img
                titleLabel.text = alreadyCheckedTitle
                gradientFunction(self, colors: [dark, light])
            }
        }else {
            if let img = UIImage(named: "ValidTicketIcon"), let dark = UIColor(named: "ValidTicketColorTwo")?.cgColor, let light = UIColor(named: "ValidTicketColorOne")?.cgColor {
                iconImage.image = img
                titleLabel.text = alreadyCheckedTitle
                gradientFunction(self, colors: [dark, light])
            }
        }
        setupView()
    }


}
