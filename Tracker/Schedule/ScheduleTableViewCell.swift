//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 21.06.2023.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let switchWeekday: UISwitch = {
       let switchWeekday = UISwitch()
        
        switchWeekday.onTintColor = .ypBlue
        switchWeekday.translatesAutoresizingMaskIntoConstraints = false
        return switchWeekday
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .ypBackgroundDay
        contentView.addSubview(titleLabel)
        contentView.addSubview(switchWeekday)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -83),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            switchWeekday.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchWeekday.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
 
    
}
