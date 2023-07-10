//
//  TrackListViewController.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 30.05.2023.
//

import UIKit
protocol TrackListViewControllerCellDelegate: AnyObject {
    func addCompletedTracker(id: UUID, indexPath: IndexPath)
    func removeCompletedTracker(id: UUID, indexPath: IndexPath)
}

class TrackListViewController: UIViewController {
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY"
        return dateFormatter
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlackDay
        label.backgroundColor = .ypDatePickerColor
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plusLarge"), for: .normal)
        button.tintColor = .ypBlackDay
        button.addTarget(self, action: #selector(pushVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.tintColor = .ypBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private let stackViewTextFieldAndButton: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ru_Ru")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.tintColor = .ypBlue
        datePicker.addTarget(self, action: #selector(weekdayAsString(date:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Поиск"
        textField.clearButtonMode = .never
        textField.backgroundColor = .ypDatePickerColor.withAlphaComponent(0.12)
        return textField
    }()
    
    private var placeholder: Placeholder = {
        let placeholder = Placeholder()
        placeholder.isHidden = true
        placeholder.bottomLabel.text = "Что будем отслеживать?"
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        return placeholder
    }()

    private var categories = DataManager.shared.categories
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
        
    private var selectedWeekday: WeekDay = .Friday
    private var currentDate: Date {
        get {
            return Date()
        }
        set {
            updateCategoriesWithNeededWeekday(weekday: selectedWeekday)
            updateDateLabel()
            setupPlaceholder()
        }
    }
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(TrackListViewControllerCell.self,
                                forCellWithReuseIdentifier: "cell")
        
        collectionView.register(TrackerListSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleView)
        view.addSubview(collectionView)
        view.addSubview(placeholder)
        
        titleView.addSubview(plusButton)
        titleView.addSubview(titleLabel)
        titleView.addSubview(stackViewTextFieldAndButton)
        titleView.addSubview(datePicker)
  
        view.addSubview(dateLabel)
        stackViewTextFieldAndButton.addArrangedSubview(searchTextField)
        stackViewTextFieldAndButton.addArrangedSubview(cancelButton)
        
        setupConstraints()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchTextField.delegate = self
        
        weekdayAsString(date: datePicker)
        
        updateDateLabel()
        
        setupPlaceholder()
    }
    
    // MARK: - Private methods
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 210),
            
            plusButton.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 45),
            plusButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 6),
            plusButton.heightAnchor.constraint(equalToConstant: 42),
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            
            titleLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 16),
            
            stackViewTextFieldAndButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            stackViewTextFieldAndButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackViewTextFieldAndButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackViewTextFieldAndButton.heightAnchor.constraint(equalToConstant: 38),
            
            dateLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -16),
            dateLabel.widthAnchor.constraint(equalToConstant: 77),
            dateLabel.heightAnchor.constraint(equalToConstant: 34),
            
            datePicker.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -16),
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            
            collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            placeholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            placeholder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    private func setupPlaceholder() {
        placeholder.isHidden = !visibleCategories.isEmpty
    }
    
    private func updateDateLabel() {
        dateLabel.text = dateFormatter.string(from: datePicker.date)
    }
    
    private func updateCategoriesWithNeededWeekday(weekday: WeekDay)  {
        let categories = categories.map({ category in
            TrackerCategory(name: category.name, trackers: category.trackers.filter({ tracker in
                tracker.schedule.contains(weekday)
            }))
        })
        
        removeEmptyCategories(categories: categories)
        collectionView.reloadData()
        
    }
    
    private func numberWeekday(date: Date) ->  Int? {
        let number = Calendar.current.dateComponents([.weekday], from: date)
        return (number.weekday ?? 1) - 1
    }
    
    private func filterSearchTextField(text: String) {
        let categories = categories.map({ category in
            TrackerCategory(name: category.name, trackers: category.trackers.filter({ tracker in
                tracker.name.lowercased().contains(text.lowercased())
            }))
        })
        
        removeEmptyCategories(categories: categories)
    }
    
    private func removeEmptyCategories(categories: [TrackerCategory]) {
        let noEmptyCategories = categories.filter { !$0.trackers.isEmpty }
        visibleCategories = noEmptyCategories
    }
    
    private func isCompletedTrackerToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSomeDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.id == id && isSomeDay
            
        }
    }
    
    @objc private func weekdayAsString(date: UIDatePicker) {
        switch numberWeekday(date: date.date) {
        case 0: selectedWeekday = WeekDay.Saturday
        case 1: selectedWeekday = WeekDay.Monday
        case 2: selectedWeekday = WeekDay.Tuesday
        case 3: selectedWeekday = WeekDay.Wednesday
        case 4: selectedWeekday = WeekDay.Thursday
        case 5: selectedWeekday = WeekDay.Friday
        case 6: selectedWeekday = WeekDay.Sunday
        default: selectedWeekday = WeekDay.Friday
        }
        currentDate = date.date
    }
    
    @objc private func pushVC() {
        navigationItem.searchController?.searchBar.endEditing(true)
        searchTextField.endEditing(true)
        let createTrackerVC = CreateTrackerViewController()
        present(createTrackerVC, animated: true)
    }
    
    @objc private func clearTextField() {
        searchTextField.text = ""
        cancelButton.isHidden = true
    }
}

// MARK: - Extensions TrackListViewControllerCellDelegate
extension TrackListViewController: TrackListViewControllerCellDelegate {
    func addCompletedTracker(id: UUID, indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func removeCompletedTracker(id: UUID, indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            let isSomeDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.id == id && isSomeDay
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - Extension UICollectionViewDataSource
extension TrackListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackListViewControllerCell else { return UICollectionViewCell() }
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        let isCompleted = isCompletedTrackerToday(id: tracker.id)
        let completedDays = completedTrackers.filter { trackerRecord in
            trackerRecord.id == tracker.id
        }.count
        
        cell.configure(tracker: tracker, date: datePicker.date, indexPath: indexPath, isCompleted: isCompleted, completedDays: completedDays)
        
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header",
            for: indexPath
        ) as? TrackerListSupplementaryView else { return  UICollectionReusableView() }
        view.titleLabel.text = visibleCategories[indexPath.section].name
        return view
    }
}

// MARK: - Extension UICollectionViewDelegateFlowLayout
extension TrackListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 2) - 20
        return CGSize(width: width, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    
}

// MARK: - Extension UITextFieldDelegate
extension TrackListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        cancelButton.isHidden = false
        
        if range.location == 0 {
            filterSearchTextField(text: string)
            collectionView.reloadData()
            setupPlaceholder()
        } else {
            filterSearchTextField(text: textField.text! + string)
            collectionView.reloadData()
            setupPlaceholder()
        }
        return true
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        cancelButton.isHidden = true
        return true
    }

}

