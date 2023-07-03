//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 05.06.2023.
//

import UIKit
protocol CategoryViewControllerDelegate: AnyObject {
    func setCategoryAndCategories(with categories: [String], and category: String)
}

protocol ScheduleViewControllerDelegate: AnyObject {
    func setWeekDays(with days: [WeekDay])
}

final class NewHabitViewController: UIViewController {
    let storageCategories = DataManager.shared.categories
    
    private var weekDays: [WeekDay] = []
    private var category = String()
    private var nameCategories: [String] = []
    private var nameTracker: String?
    
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
        collectionView.register(NewHabitViewControllerEmojisCell.self,
                                forCellWithReuseIdentifier: "cell")
        collectionView.register(SupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        
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
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var stackMovableErrorLabel: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var indexSelectedEmojiCell = IndexPath()
    private var indexSelectedColorCell = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(tableView)
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
        
        storageCategories.forEach { nameCategory in
            nameCategories.append(nameCategory.name)
        }
      
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            backgroundLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 38),
            backgroundLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            backgroundLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            backgroundLabel.heightAnchor.constraint(equalToConstant: 75),
            
            nameTrackerTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 65),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            
            tableView.topAnchor.constraint(equalTo: stackMovableErrorLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            collectionView.trailingAnchor.constraint(equalTo:  containerView.trailingAnchor, constant: -25),
            collectionView.heightAnchor.constraint(equalToConstant: 492),
            
            stackButtons.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            stackButtons.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackButtons.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackButtons.heightAnchor.constraint(equalToConstant: 60),
            stackButtons.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            stackMovableErrorLabel.topAnchor.constraint(equalTo: backgroundLabel.bottomAnchor),
            stackMovableErrorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackMovableErrorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }
    
    @objc private func createButtonTapped() {
        let tracker = Tracker(id: UUID(),
                              name: nameTracker ?? "Tracker",
                              color: colors[indexSelectedColorCell.row],
                              emoji: emojis[indexSelectedEmojiCell.row],
                              schedule: weekDays)
        
        let categoryName = category
        
        if storageCategories.contains(where: { $0.name == categoryName }) {
            DataManager.shared.createAndAddReplacedCategory(
                nameCategory: categoryName,
                tracker: tracker
            )
            
        } else {
            DataManager.shared.createAndAddCategory(nameCategory: categoryName, tracker: tracker)
        }
    }
    
    private func activateCreateButton() {
        if  !nameCategories.isEmpty &&
                !weekDays.isEmpty &&
                nameTracker != nil &&
                nameTracker != "" &&
                !indexSelectedEmojiCell.isEmpty &&
                !indexSelectedColorCell.isEmpty
        {
            createButtonState(color: .ypBlackDay, isActive: true)
        } else {
            createButtonState(color: .ypGray, isActive: false)
        }
    }
    
    private func createButtonState(color: UIColor, isActive: Bool) {
        createButton.backgroundColor = color
        createButton.isEnabled = isActive
    }
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NewHabitViewControllerEmojisCell else { return UICollectionViewCell() }
            cell.titleLabel.text = emojis[indexPath.row]
            return cell
            
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? NewHabitViewControllerColorCell else { return UICollectionViewCell() }
        cell.titleLabel.backgroundColor = colors[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            guard let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? SupplementaryView else { return UICollectionReusableView() }
            
            view.titleLabel.text = "Emoji"
            return view
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header",
            for: indexPath
        ) as? SupplementaryView else { return UICollectionReusableView() }
        
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
        return CGSize(width: collectionView.frame.width, height: 81)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets { return UIEdgeInsets(top: 0, left: 0, bottom: 14, right: 0)
        
    }
    
}

extension NewHabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let beforeCell = collectionView.cellForItem(at: indexSelectedEmojiCell) as? NewHabitViewControllerEmojisCell
            beforeCell?.titleLabel.backgroundColor = .white
            indexSelectedEmojiCell = indexPath
            let cell = collectionView.cellForItem(at: indexPath) as? NewHabitViewControllerEmojisCell
            cell?.titleLabel.backgroundColor = .ypLightGray
            activateCreateButton()
        } else {
            
            let beforeCell = collectionView.cellForItem(at: indexSelectedColorCell) as? NewHabitViewControllerColorCell
            beforeCell?.borderView.layer.borderColor = UIColor.clear.cgColor
            indexSelectedColorCell = indexPath
            let cell = collectionView.cellForItem(at: indexPath) as? NewHabitViewControllerColorCell
            let color = colors[indexPath.row]
            cell?.borderView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
            activateCreateButton()
        }
    }
    
}

extension NewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? NewHabitTableViewCell else { return UITableViewCell() }
        cell.titleCellLabel.text = tableViewItems[indexPath.row]
        if indexPath.row == 1 {
            cell.configureScheduleCell(weekDays)
        } else {
            cell.addedLabelInCell.text = category
        }
        cell.backgroundColor = .ypBackgroundDay
        return cell
    }
}

extension NewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        nameTrackerTextField.endEditing(true)
        if indexPath.row == 1 {
            let vc = ScheduleViewController()
            vc.delegate = self
            present(vc, animated: true)
        }
        let vc = CategoryViewController()
        vc.delegate = self
        vc.categories = nameCategories
        present(vc, animated: true)
    }
}

extension NewHabitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        
        if range.location == 3 {
            stackMovableErrorLabel.addArrangedSubview(errorLabel)
            errorLabel.isHidden = false
            return false
        }
        
        if !errorLabel.isHidden {
            errorLabel.isHidden = true
            return true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        errorLabel.isHidden = true
        nameTracker = ""
        activateCreateButton()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        nameTracker = textField.text
        activateCreateButton()
        return true
    }
    
}

extension NewHabitViewController: ScheduleViewControllerDelegate {
    func setWeekDays(with days: [WeekDay]) {
        weekDays = days
        activateCreateButton()
        tableView.reloadData()
    }
}

extension NewHabitViewController: CategoryViewControllerDelegate {
    func setCategoryAndCategories(with categories: [String],and category: String) {
        self.nameCategories = categories
        self.category = category
        activateCreateButton()
        tableView.reloadData()
    }
}
