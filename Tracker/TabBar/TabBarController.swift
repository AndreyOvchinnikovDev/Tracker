//
//  TabBarController.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 30.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            setViewControllers(
                viewController: TrackListViewController(),
                title: "Трекеры",
                image: nil
            ),
            setViewControllers(
                viewController: StatisticViewController(),
                title: "Статистика",
                image: nil
            )
        ]
    }
    
    private func setViewControllers(
        viewController: UIViewController,
        title: String,
        image: UIImage?
    ) -> UIViewController {
        
        viewController.tabBarItem = UITabBarItem(
            title: title,
            image: title == "Трекеры" ? UIImage(named: "record.circle.fill")
                                      : UIImage(named: "hare.fill"),
            selectedImage: nil)
        viewController.tabBarItem.title = title
        return viewController
    }
}
