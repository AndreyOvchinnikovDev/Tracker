//
//  TrackerListSupplementaryView.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 04.07.2023.
//

import UIKit

class TrackerListSupplementaryView: UICollectionReusableView {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .ypBlackDay
        titleLabel.font = .systemFont(ofSize: 19, weight: .bold)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
