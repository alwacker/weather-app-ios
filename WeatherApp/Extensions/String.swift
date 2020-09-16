//
//  String.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 16/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation

extension String {
    var dateItem: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self) ?? Date()
    }
    
    var formatDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: self) ?? Date()
    }
    
    var formatTime: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.date(from: self) ?? Date()
    }
}
