//
//  Int + Extensions.swift
//  Tracker
//
//  Created by Andrey Ovchinnikov on 12.07.2023.
//

import Foundation

extension Int {
    func completedDaysString() -> String {
        var dayString: String = ""
        if "1".contains("\(self % 10)")      {dayString = "день"}
        if "234".contains("\(self % 10)")    {dayString = "дня" }
        if "567890".contains("\(self % 10)") {dayString = "дней"}
        if 11...14 ~= self % 100             {dayString = "дней"}
        
        return "\(self) " + dayString
    }
}
