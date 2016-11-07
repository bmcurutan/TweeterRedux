//
//  Date+OffsetFrom.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/30/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

extension Date {
    
    // Hours and min seems sufficient for this app, but this function can be extended to include other units also
    func offsetFrom(dateString: String!) -> String {
        
        var formattedString = dateString
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        if let date = formatter.date(from: dateString) {
            let dayHourMinuteSecond: Set<Calendar.Component> = [.hour, .minute, .second]
            let difference = Calendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)
            let seconds = "\(difference.second!)m"
            let minutes = "\(difference.minute!)m"
            let hours = "\(difference.hour!)h"
            
            if difference.hour! > 24 {
                formatter.dateStyle = .medium
                formattedString = formatter.string(from: date)
            } else if difference.hour! > 0 {
                formattedString = hours
            } else if difference.minute! > 0 {
                formattedString = minutes
            } else if difference.second! > 0 {
                formattedString = seconds
            } else if difference.hour! == 0 && difference.minute! == 0 && difference.second! == 0 {
                formattedString = "Just now"
            }
        }
        
        return formattedString!
    }
    
}
