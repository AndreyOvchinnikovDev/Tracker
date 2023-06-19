//
//  NewHabitViewControllerCell.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 05.06.2023.
//

import UIKit

final class NewHabitViewControllerCell: UICollectionViewCell {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.backgroundColor = .ypLightGray
        titleLabel.font = .systemFont(ofSize: 32)
        titleLabel.textAlignment = .center
        titleLabel.layer.cornerRadius = 16
        titleLabel.layer.masksToBounds = true
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 52),
            titleLabel.widthAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class NewHabitViewControllerColorCell: UICollectionViewCell {
    let titleLabel = UILabel()
    let borderView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(borderView)
        borderView.layer.cornerRadius = 11
        borderView.layer.borderWidth = 3
        borderView.layer.borderColor = UIColor.colorSection5.withAlphaComponent(0.3).cgColor
        titleLabel.layer.cornerRadius = 8
        titleLabel.layer.masksToBounds = true
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.widthAnchor.constraint(equalToConstant: 40),
            borderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            borderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            borderView.widthAnchor.constraint(equalToConstant: 52),
            borderView.heightAnchor.constraint(equalToConstant: 52)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
