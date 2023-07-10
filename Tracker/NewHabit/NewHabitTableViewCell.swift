//
//  NewHabitTableViewCell.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 08.06.2023.
//

import UIKit

final class NewHabitTableViewCell: UITableViewCell {
    let titleCellLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlackDay
        return label
    }()
    
    let addedLabelInCell: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleCellLabel)
        stackView.addArrangedSubview(addedLabelInCell)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureScheduleCell(_ weekDays: [WeekDay]) {
        if weekDays.count == 7 {
            addedLabelInCell.text = "Каждый день"
        } else {
            let textArray = weekDays.map { $0.rawValue }
            let text = textArray.joined(separator: ",")
            addedLabelInCell.text = text
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
