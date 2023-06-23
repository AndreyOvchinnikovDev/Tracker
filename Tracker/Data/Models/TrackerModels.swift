//
//  TrackerModels.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 23.06.2023.
//

import Foundation
import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
}

struct TrackerCategory {
    let name: String
    let categories: [Tracker]
}

struct TrackerRecord {
    let id: UUID
    let date: Date
}
