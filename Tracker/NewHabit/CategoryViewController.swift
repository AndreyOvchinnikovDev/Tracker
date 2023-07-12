//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 25.06.2023.
//

import UIKit
protocol NewCategoryViewControllerDelegate: AnyObject {
    func addCategory(category: String)
}

final class CategoryViewController: UIViewController {
    var category = String()
    var categories = [String]()
    weak var delegate: CategoryViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset.right = 20
        tableView.layer.cornerRadius = 16
        tableView.register(CategoryTableViewCell.self,
                           forCellReuseIdentifier: "tableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Добавить категорию", for: .normal)
        button.tintColor = .ypWhiteDay
        button.backgroundColor = .ypBlackDay
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addCategoryTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)
        setupConstraints()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - private methods
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -16),
            
            addCategoryButton.bottomAnchor.constraint(equalTo:   view.bottomAnchor, constant: -50),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc private func addCategoryTapped() {
        let vc = NewCategoryViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
}

// MARK: - extension UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        cell.nameCategory.text = categories[indexPath.row]
        cell.backgroundColor = .ypBackgroundDay
        
        return cell
    }
}

// MARK: - extension UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        category = categories[indexPath.row]
        delegate?.setCategoryAndCategories(with: categories, and: category)
        dismiss(animated: true)
    }
}

// MARK: - extension NewCategoryViewControllerDelegate
extension CategoryViewController: NewCategoryViewControllerDelegate {
    func addCategory(category: String) {
        if !categories.contains(category) {
            self.categories.append(category)
        }
        tableView.reloadData()
    }
}



