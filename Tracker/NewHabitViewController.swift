//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 05.06.2023.
//

import UIKit

final class NewHabitViewController: UIViewController {
    
    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                          "😇" , "😡", "🥶", "🤔", "🙌", "🍔",
                          "🥦" , "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    private let colors: [UIColor] = [.colorSection1, .colorSection2, .colorSection3, .colorSection4, .colorSection5, .colorSection6, .colorSection7, .colorSection8, .colorSection9, .colorSection10, .colorSection11, .colorSection12, .colorSection13, .colorSection14, .colorSection15, .colorSection16,.colorSection17, .colorSection18]
    
    private let tableViewItems = ["Категория", "Расписание"]
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset.right = 20
        tableView.layer.cornerRadius = 16
        tableView.register(NewHabitTableViewCell.self,
                           forCellReuseIdentifier: "tableCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(NewHabitViewControllerColorCell.self,
                                forCellWithReuseIdentifier: "colorCell")
        collectionView.register(NewHabitViewControllerCell.self,
                                forCellWithReuseIdentifier: "cell")
        collectionView.register(SupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backgroundLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .ypBackgroundDay
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.heightAnchor.constraint(equalToConstant: 38).isActive = true
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        label.text = "Ограничение 38 символов"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTrackerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Создать", for: .normal)
        button.tintColor = .ypWhiteDay
        button.backgroundColor = .ypBlackDay
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .light)
        button.setTitle("Отменить", for: .normal)
        button.tintColor = .red
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let stackButtons: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.frame.size = contentSize
        return contentView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame.size = contentSize
        return view
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 150)
    }
    
    private var stackMovableErrorLabel: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var neededScrollViewHeightChange = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(containerView)
        contentView.addSubview(tableView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(backgroundLabel)
        containerView.addSubview(nameTrackerTextField)
        containerView.addSubview(collectionView)
        containerView.addSubview(stackButtons)
        containerView.addSubview(stackMovableErrorLabel)
        stackButtons.addArrangedSubview(cancelButton)
        stackButtons.addArrangedSubview(createButton)
        
        setupConstraints()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        nameTrackerTextField.delegate = self
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            nameTrackerTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 65),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            
            stackMovableErrorLabel.topAnchor.constraint(equalTo: backgroundLabel.bottomAnchor),
            stackMovableErrorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackMovableErrorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            backgroundLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 38),
            backgroundLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            backgroundLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            backgroundLabel.heightAnchor.constraint(equalToConstant: 75),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo:  containerView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 525),
            
            stackButtons.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            stackButtons.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackButtons.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackButtons.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.topAnchor.constraint(equalTo: stackMovableErrorLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    //    private func setupSubviews(_ subviews: UIView...) {
    //        subviews.forEach { subview in
    //            stackView.addSubview(subview)
    //            subview.translatesAutoresizingMaskIntoConstraints = false
    //        }
    //    }
    
}

extension NewHabitViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NewHabitViewControllerCell else { return UICollectionViewCell() }
            cell.titleLabel.text = emojis[indexPath.row]
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? NewHabitViewControllerColorCell else { return UICollectionViewCell() }
        cell.titleLabel.backgroundColor = colors[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? SupplementaryView else { return UICollectionReusableView() }
            view.titleLabel.text = "Emoji"
            return view
        }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? SupplementaryView else { return UICollectionReusableView() }
        view.titleLabel.text = "Цвет"
        return view
    }
}
extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 6, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets { return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
    }
    
}

extension NewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItems.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? NewHabitTableViewCell else { return UITableViewCell() }
        cell.categoryLabel.text = tableViewItems[indexPath.row]
        cell.backgroundColor = .ypBackgroundDay
        return cell
    }
}

extension NewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewHabitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        
        if range.location == 3 {
            stackMovableErrorLabel.addArrangedSubview(errorLabel)
            errorLabel.isHidden = false
            if neededScrollViewHeightChange == true {
                neededScrollViewHeightChange = false
                scrollView.contentSize.height += 38
            }
            
            return false
        }
        
        if !errorLabel.isHidden {
            neededScrollViewHeightChange = true
            errorLabel.isHidden = true
            scrollView.contentSize.height -= 38
            return true
        }
        
        return true
    }
    
}
