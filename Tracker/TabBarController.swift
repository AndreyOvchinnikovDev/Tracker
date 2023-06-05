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
        viewControllers = [setViewControllers(viewController: TrackListViewController(), title: "Home", image: nil), setViewControllers(viewController: StatisticViewController(), title: "second", image: nil)]
    }
    private func setViewControllers(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
      let vc = UINavigationController(rootViewController: viewController)
        vc.navigationBar.prefersLargeTitles = true
        UINavigationBar.appearance().tintColor = .black
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        return vc
    }
}
