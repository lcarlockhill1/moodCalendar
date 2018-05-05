//
//  dataExtension.swift
//  moodCalendar
//
//  Created by LisaBebe11 on 5/5/18.
//  Copyright © 2018 LisaBebe11. All rights reserved.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
}
