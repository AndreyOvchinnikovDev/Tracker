//
//  TrackListViewControllerCell.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 02.07.2023.
//

import UIKit

final class TrackListViewControllerCell: UICollectionViewCell {
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .colorSection5
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 17
        button.tintColor = .white
       // button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let countDaysLabel: UILabel = {
        let label = UILabel()
        label.text = "1 день"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .ypBlackDay
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "🙂"
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.backgroundColor = .white.withAlphaComponent(0.3)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTrackerLabel: UILabel = {
        let label = UILabel()
        label.text = "Поливать ратения"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .ypWhiteDay
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bottomView)
        contentView.addSubview(plusButton)
        contentView.addSubview(countDaysLabel)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(nameTrackerLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bottomView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bottomView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 90),
            bottomView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            plusButton.topAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -12),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            
            countDaysLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            countDaysLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 12),
            
            emojiLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 12),
            
            nameTrackerLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -12),
            nameTrackerLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 12),
            nameTrackerLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -12)
            
        ])
    }
    
    func configure(emoji: String, nameTracker: String, color: UIColor ) {
        emojiLabel.text = emoji
        nameTrackerLabel.text = nameTracker
        bottomView.backgroundColor = color
        plusButton.backgroundColor = color
    }
}
