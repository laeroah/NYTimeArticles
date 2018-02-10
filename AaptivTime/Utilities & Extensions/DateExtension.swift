//
//  DateExtension.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/10/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import Foundation

extension Date {

    static let formatter = DateFormatter()

    func shortArticleDateLabelString() -> String {

        let components = Calendar.current.dateComponents(
            [.year, .month, .weekOfYear, .day, .hour, .minute, .second],
            from: self,
            to: Date()
        )

        if let hours = components.hour {
            if hours >= 24 {
                Date.formatter.dateFormat = "M/dd/yy"
                return Date.formatter.string(from: self)
            } else if hours > 0 {
                return "\(hours)h"
            }
        }
        
        if let minutes = components.minute, minutes > 0 {
            return "\(minutes)m"
        }

        if let seconds = components.second, seconds > 30 {
            return "\(seconds)s"
        }

        return "just now"
    }
}
