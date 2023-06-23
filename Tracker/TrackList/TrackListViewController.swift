//
//  TrackListViewController.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 30.05.2023.
//

import UIKit

class TrackListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Трекеры"
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushVC))
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        setSearchController()
    }
    
    private func setSearchController() {
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        searchController.searchBar.searchTextField.clearButtonMode = .never
        navigationItem.searchController = searchController
        }
    
    @objc func pushVC() {
        let createTrackerVC = CreateTrackerViewController()
        present(createTrackerVC, animated: true)
    }
    }
    






