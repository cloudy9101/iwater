//
//  CalendarData.swift
//  iWater
//
//  Created by cloudy on 2018/5/20.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import Foundation

class CalendarData {
    var date: Date
    var dayCountOfCurrentMonth = 31
    var firstDateOfMonth = Date()
    var endDateOfMonth = Date()
    var weekdayOfFirstDay = 1
    var weekdayOfEndDay = 1
    let calendar = Calendar.current
    static let weekHeaders = ["Sun", "Mon", "Tue", "Wed", "Tur", "Fri", "Sat"]
    
    init(date: Date) {
        self.date = date
        dayCountOfCurrentMonth = dayCount(date)
        firstDateOfMonth = calendar.date(byAdding: Calendar.Component.day, value: 1 - calendar.component(Calendar.Component.day, from: date), to: date)!
        endDateOfMonth = calendar.date(byAdding: Calendar.Component.day, value: dayCountOfCurrentMonth - calendar.component(Calendar.Component.day, from: date), to: date)!
        
        weekdayOfFirstDay = calendar.component(Calendar.Component.weekday, from: firstDateOfMonth)
        weekdayOfEndDay = calendar.component(Calendar.Component.weekday, from: endDateOfMonth)
    }
    
    func dateArray() -> [Date] {
        let prevDayLeave = weekdayOfFirstDay - 1
        let firstDate = calendar.date(byAdding: Calendar.Component.day, value: -prevDayLeave, to: firstDateOfMonth)
        let endDayLeave = 7 - weekdayOfEndDay
        let dayCount = prevDayLeave + dayCountOfCurrentMonth + endDayLeave
        var dates: [Date] = []
        var i = 0
        while i < dayCount {
            dates.append(calendar.date(byAdding: Calendar.Component.day, value: i, to: firstDate!)!)
            i = i + 1
        }
        return dates
    }
    
    func dateInPrevMonth(_ date: Date) -> Date? {
        return calendar.date(byAdding: Calendar.Component.month, value: -1, to: date)
    }
    
    func dayCount(_ date: Date) -> Int {
        let year = calendar.component(Calendar.Component.year, from: date)
        let month = calendar.component(Calendar.Component.month, from: date)
        var dayCount: Int
        switch month {
        case 4, 6, 9, 11:
            dayCount = 30
        case 2:
            if year % 400 == 0 || (year % 4 == 0 && year % 100 != 0) {
                dayCount = 29
            } else {
                dayCount = 28
            }
        default:
            dayCount = 31
        }
        return dayCount
    }
}
