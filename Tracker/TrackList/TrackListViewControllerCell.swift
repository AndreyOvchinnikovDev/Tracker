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
        //  button.isEnabled = true
        button.layer.cornerRadius = 17
        button.tintColor = .white
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var countDaysLabel: UILabel = {
        let label = UILabel()
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
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textColor = .ypWhiteDay
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var delegate: TrackListViewControllerCellDelegate?
    
    private var idTracker: UUID?
    private var isCompleted = false
    private var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func configure(tracker: Tracker, date: Date, indexPath: IndexPath, isCompleted: Bool, completedDays: Int) {
        emojiLabel.text = tracker.emoji
        nameTrackerLabel.text = tracker.name
        bottomView.backgroundColor = tracker.color
        idTracker = tracker.id
        self.indexPath = indexPath
        self.isCompleted = isCompleted
        
        countDaysLabel.text = completedDays.completedDaysString()
        
        let image = !isCompleted ? UIImage(systemName: "plus") : UIImage(systemName: "checkmark")
        plusButton.setImage(image, for: .normal)
        
        let buttonColorAlpha = !isCompleted ? tracker.color : tracker.color.withAlphaComponent(0.3)
        plusButton.backgroundColor = buttonColorAlpha
        
        let dateTracker = Calendar.current.dateComponents([.day], from: date)
        let dateToday = Calendar.current.dateComponents([.day], from: Date())
        
        guard let dateTracker = dateTracker.day, let dateToday = dateToday.day else { return }
        if dateTracker > dateToday {
            plusButton.isEnabled = false
        } else {
            plusButton.isEnabled = true
        }
    }
    
    // MARK: - Private methods
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
    
    private func addSubviews() {
        contentView.addSubview(bottomView)
        contentView.addSubview(plusButton)
        contentView.addSubview(countDaysLabel)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(nameTrackerLabel)
    }
    
    @objc private func plusButtonTapped() {
        guard let idTracker,  let indexPath else { return }
        if !isCompleted {
            delegate?.addCompletedTracker(id: idTracker, indexPath: indexPath)
        } else {
            delegate?.removeCompletedTracker(id: idTracker, indexPath: indexPath)
        }
    }
}

