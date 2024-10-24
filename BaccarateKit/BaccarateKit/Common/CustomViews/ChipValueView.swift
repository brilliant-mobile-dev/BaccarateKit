//
//  ChipValueView.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 28/09/23.
//

import Foundation
import UIKit

class ChipValueView: UIView {
    func setSelfStatus() {
        self.roundView.backgroundColor = .appYellow
    }
    private let playerNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = .appFont(family: .medium, size: 12)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appYellow
        label.textAlignment = .left
        label.font = .appFont(family: .medium, size: 12)
        return label
    }()
    
    private let roundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = .white
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
    }
    func addView() {
        self.backgroundColor = .black.withAlphaComponent(0.6)
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(roundView)
        
        roundView.addSubview(playerNumberLabel)
        
        addSubview(amountLabel)
        
        translatesAutoresizingMaskIntoConstraints = false
        playerNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        roundView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up Auto Layout constraints
        NSLayoutConstraint.activate([
            roundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            roundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            roundView.widthAnchor.constraint(equalToConstant: 14),
            roundView.heightAnchor.constraint(equalToConstant: 14),
            
            playerNumberLabel.centerXAnchor.constraint(equalTo: roundView.centerXAnchor),
            playerNumberLabel.centerYAnchor.constraint(equalTo: roundView.centerYAnchor),
            
            amountLabel.leadingAnchor.constraint(equalTo: roundView.trailingAnchor, constant: 4),
            amountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            amountLabel.topAnchor.constraint(equalTo: topAnchor),
            amountLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            // Set Dynamic widthAnchor to UILabel based on its text size
            amountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 16)
        ])
    }
    func updateView(player: String, amount: String) {
        playerNumberLabel.text = player
        amountLabel.text = amount
        translatesAutoresizingMaskIntoConstraints = false
    }
    override func setNeedsLayout() {
        super.setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
