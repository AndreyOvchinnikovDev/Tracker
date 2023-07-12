//
//  Placeholder.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 10.07.2023.
//

import UIKit

final class Placeholder: UIView {
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "placeholder")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(bottomLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            bottomLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            bottomLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
    }
}

