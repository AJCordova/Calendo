//
//  EventModel.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/12/22.
//

import Foundation

struct EventModel: Codable {
    let name: String
    let startDate: Date
    let endDate: Date
    let isAllDay: Bool
}

struct sampleEvents {
    static let events: [EventModel] = [
        EventModel(name: "Jogging",
                   startDate: createDate(month: 5, day: 12, hour: 7, minute: 0)!,
                   endDate: createDate(month: 5, day: 12, hour: 8, minute: 0)!,
                   isAllDay: false),
        EventModel(name: "Work",
                   startDate: createDate(month: 5, day: 13, hour: 9, minute: 30)!,
                   endDate: createDate(month: 5, day: 13, hour: 15, minute: 0)!,
                   isAllDay: true),
        EventModel(name: "Hiking",
                   startDate: createDate(month: 5, day: 14, hour: 7, minute: 0)!,
                   endDate: createDate(month: 5, day: 14, hour: 17, minute: 0)!,
                   isAllDay: true),
        EventModel(name: "Cleaning",
                   startDate: createDate(month: 5, day: 15, hour: 13, minute: 0)!,
                   endDate: createDate(month: 5, day: 15, hour: 15, minute: 0)!,
                   isAllDay: false),
        EventModel(name: "Vacation",
                   startDate: createDate(month: 5, day: 16, hour: 7, minute: 0)!,
                   endDate: createDate(month: 5, day: 21, hour: 7, minute: 0)!,
                   isAllDay: true)
    ]
    
    static func createDate(month: Int, day: Int, hour: Int, minute: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = 2022
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = TimeZone.current
        dateComponents.hour = hour
        dateComponents.minute = minute

        // Create date from components
        let userCalendar = Calendar(identifier: .gregorian) // since the components above (like year 1980) are for Gregorian
        guard let someDateTime = userCalendar.date(from: dateComponents) else { return nil}
        return someDateTime
    }
}
