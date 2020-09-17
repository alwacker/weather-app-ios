//
//  ForecastEntity.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 16/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation


struct ForecastEntity: Decodable {
    let list: [WeatherItem]
}

struct WeatherItem: Decodable, Equatable {
    let main: Temperatures
    let weather: [Weather]
    let dt_txt: String //date
    let dt: Int //date timestamp
    
    var dateId: String {
        let dateComponents = dateItem.dateComponents
        return "\(dateComponents.day ?? 0)-\(dateComponents.month ?? 0)-\(dateComponents.year ?? 0)"
    }
    
    var time: String {
        let dateComponents = dateItem.dateComponents
        if let hour = dateComponents.hour, let minute = dateComponents.minute {
            let formattedHour = hour < 10 ? "0\(hour)" : "\(hour)"
            let formattedMinute = minute < 10 ? "0\(minute)" : "\(minute)"
            return "\(formattedHour):\(formattedMinute)"
        }
        return ""
    }
    
    var dateItem: Date {
        return dt_txt.dateItem
    }
    
    static func == (lhs: WeatherItem, rhs: WeatherItem) -> Bool {
           return lhs.main == rhs.main
               && lhs.weather == rhs.weather
               && lhs.dt_txt == rhs.dt_txt
               && lhs.dt == rhs.dt
       }
}
