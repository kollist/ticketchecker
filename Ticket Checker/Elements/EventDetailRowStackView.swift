//
//  EventDetailRowView.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 21/10/2024.
//

import UIKit
import UIKit

class EventDetailRowStackView: UIStackView {
    
    private lazy var lblKey: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .gray
        lbl.font = .preferredFont(forTextStyle: .caption1)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var lblValue: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .label
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = 8
        
        // Add labels to the stack view
        addArrangedSubview(lblKey)
        addArrangedSubview(lblValue)
        
        // Set constraints for the labels if needed
        // For example, you can add constraints to limit the width of lblKey if necessary
    }

    func config(key: String, value: String, fontWeight: UIFont.Weight = .regular) {
        lblKey.text = key
        lblValue.text = value
        lblValue.font = .systemFont(ofSize: 12, weight: fontWeight)
    }
}
