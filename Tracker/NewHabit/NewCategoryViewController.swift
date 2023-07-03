//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 24.06.2023.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Готово", for: .normal)
        button.isEnabled = false
        button.tintColor = .ypWhiteDay
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(completeCreateCategory), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let backgroundLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .ypBackgroundDay
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameCategoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    weak var delegate: NewCategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(addCategoryButton)
        view.addSubview(backgroundLabel)
        view.addSubview(nameCategoryTextField)
        
        setupConstraints()
        
        nameCategoryTextField.delegate = self
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addCategoryButton.bottomAnchor.constraint(equalTo:   view.bottomAnchor, constant: -50),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            
            backgroundLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 38),
            backgroundLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backgroundLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backgroundLabel.heightAnchor.constraint(equalToConstant: 75),
            
            nameCategoryTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 65),
            nameCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            nameCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
        ])
    }
    
    @objc private func completeCreateCategory() {
        delegate?.addCategory(category: nameCategoryTextField.text ?? "empty row")
        dismiss(animated: true)
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        addCategoryButton.backgroundColor = .ypBlackDay
        addCategoryButton.isEnabled = true
        
        return true
    }
}
