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
            name: "Work",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "go work",
                    color: .colorSection1,
                    emoji: "🙂",
                    schedule: [.Friday, .Saturday]
                ),
                Tracker(
                    id: UUID(),
                    name: "comeback",
                    color: .colorSection13,
                    emoji: "😻",
                    schedule: [.Monday, .Sunday]
                ),
                Tracker(
                    id: UUID(),
                    name: "chill",
                    color: .colorSection13,
                    emoji: "😻",
                    schedule: [.Monday, .Sunday]
                )

            ]
        ),
        TrackerCategory(
            name: "Learning",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "study",
                    color: .colorSection10,
                    emoji: "🌺",
                    schedule: [.Sunday, .Monday, .Wednesday]
                )
            ]
        )
    ]
        
    private init() {}
    
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



