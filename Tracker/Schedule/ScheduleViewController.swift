//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 20.06.2023.
//

import UIKit
enum WeekDay: String, CaseIterable {
 
    case Monday = "Пн"
    case Tuesday = "Вт"
    case Wednesday = "Ср"
    case Thursday = "Чт"
    case Friday = "Пт"
    case Saturday = "Сб"
    case Sunday = "Вс"
}


class ScheduleViewController: UIViewController {

    weak var delegate: ScheduleViewControllerDelegate!
    
    private let tableViewItems = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    var weekDays = [WeekDay]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.separatorInset.right = 20
        tableView.layer.cornerRadius = 16
        tableView.register(ScheduleTableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Готово", for: .normal)
        button.tintColor = .ypWhiteDay
        button.backgroundColor = .ypBlackDay
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(setDays), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(tableView)
        containerView.addSubview(completeButton)
                
        setupConstraints()
        
        tableView.dataSource = self
        tableView.delegate = self
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
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 39),
            tableView.leadingAnchor.constraint(equalTo:containerView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            completeButton.bottomAnchor.constraint(equalTo:   containerView.bottomAnchor, constant: -20),
            completeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 60),
            completeButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 47),
            
        ])
    }
    
     @objc func setDays() {
         delegate?.setWeekDays(with: weekDays)
         dismiss(animated: true)
    }
    
     @objc func switchDidTapped(_ sender: UISwitch!) {
         let days = WeekDay.allCases
         if sender.isOn {
             weekDays.append(days[sender.tag])
         } else {
           if let index = weekDays.firstIndex(of: days[sender.tag]) {
                 weekDays.remove(at: index)
             }
         }
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ScheduleTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = tableViewItems[indexPath.row]
        cell.switchWeekday.tag = indexPath.row
        cell.switchWeekday.addTarget(self, action: #selector(self.switchDidTapped(_:)), for: .valueChanged)
        cell.backgroundColor = .ypBackgroundDay
        return cell
        
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

