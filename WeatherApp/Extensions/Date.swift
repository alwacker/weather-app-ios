//
//  Date.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 16/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation

extension Date {
    var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    var dateComponents: DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
    }
}
