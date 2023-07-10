//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 03.06.2023.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlackDay
        return label
    }()
    
    private let habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(newHabit), for: .touchUpInside)
        button.setTitle("Привычка", for:.normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlackDay
        button.tintColor = .ypWhiteDay
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let irregularEvent: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нерегулярное событие", for:.normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlackDay
        button.tintColor = .ypWhiteDay
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
           setupSubviews(habitButton, irregularEvent, titleLabel)
           setupConstraints()
    }
    
    // MARK: - Private methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            irregularEvent.heightAnchor.constraint(equalToConstant: 60),
            irregularEvent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            irregularEvent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            irregularEvent.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16)
        ])
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @objc private func newHabit() {
        let vc = NewHabitViewController()
        present(vc, animated: true)
    }
 }
