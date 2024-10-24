//
//  SuccessPopupView.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 05/10/23.
//

import Foundation

import UIKit

class SuccessPopupView: UIView {
    
    // MARK: - Properties
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .appFont(family: .medium, size: 16)
        label.textColor = .darkGray
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .appFont(family: .demibold, size: 40)
        label.textColor = .black
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ok".localizable, for: .normal)
        button.setTitleColor(.secondaryDark, for: .normal)
        button.titleLabel?.font = .appFont(family: .demibold, size: 16)
        button.backgroundColor = .appYellow
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Initialization
    
    init(header: String, price: String) {
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)
        
        priceLabel.text = price
        headerLabel.text = header
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        addSubview(headerLabel)
        addSubview(priceLabel)
        addSubview(closeButton)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            priceLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            closeButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            closeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 80),
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            closeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
