//
//  DataManager.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 23.06.2023.
//

import Foundation

final class DataManager {
    static let shared = DataManager()
    
    var categories: [TrackerCategory] = [
        TrackerCategory(
            name: "Учеба",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "сделать домашку",
                    color: .colorSection1,
                    emoji: "🙂",
                    schedule: [.Friday, .Thursday, .Saturday, .Monday, .Wednesday, .Tuesday]
                ),
                Tracker(
                    id: UUID(),
                    name: "пройти новый материал",
                    color: .colorSection13,
                    emoji: "😻",
                    schedule: [.Monday]
                ),
                Tracker(
                    id: UUID(),
                    name: "еще раз пройти новый материал",
                    color: .colorSection13,
                    emoji: "😻",
                    schedule: [.Saturday]
                ),
                Tracker(
                    id: UUID(),
                    name: "и еще раз",
                    color: .colorSection7,
                    emoji: "😻",
                    schedule: [.Saturday]
                )
            ]
        ),
        
        TrackerCategory(
            name: "Уборка",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "Убираться пока не уберешься",
                    color: .colorSection10,
                    emoji: "🌺",
                    schedule: [.Saturday, .Monday, .Wednesday]
                )
            ]
        )
    ]
        
    private init() {}
    
    // MARK: - Public Methods
    func createAndAddReplacedCategory(nameCategory: String, tracker: Tracker) {
        let existCategory = categories.filter { $0.name == nameCategory }
        var newTrackers = [Tracker]()
        existCategory.forEach { newTrackers += $0.trackers }
        newTrackers.append(tracker)
        
        let replacedCategory = TrackerCategory(name: nameCategory, trackers: newTrackers)
        var newCategories = [TrackerCategory]()
        newCategories = categories
        if let index = newCategories.firstIndex(where: { $0.name == nameCategory }) {
            newCategories[index] = replacedCategory
        }
        categories = newCategories
    }
    
    func createAndAddCategory(nameCategory: String, tracker: Tracker) {
        var newCategories = [TrackerCategory]()
        newCategories = categories
        
        let newCategory = TrackerCategory(name: nameCategory, trackers: [tracker])
        newCategories.append(newCategory)
        categories = newCategories
    }
}



