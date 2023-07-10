//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 25.06.2023.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    let nameCategory: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameCategory)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            nameCategory.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameCategory.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameCategory.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
