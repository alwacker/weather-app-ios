//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 15/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation

struct CurrentWeather: Decodable {
    let name: String
    let weather: [Weather]
    let main: Temperatures
    let wind: Wind
    let sys: System?
    
    var fullNameLocation: String {
        if let sys = sys {
            return "\(name)" + ", \(sys.country ?? "")"
        } else {
            return name
        }
    }
}

struct System: Decodable {
    let country: String?
}

struct Weather: Decodable {
    let main: String
    let icon: String
    let description: String
    
    var truncateDescription: String {
        return description.replacingOccurrences(of: " ", with: "_") + dayTime
    }
    
    var dayTime: String {
        if icon.contains("n") {
            return "_night"
        } else {
            return "_day"
        }
    }
}

struct Temperatures: Decodable {
    let temp: Float
    let pressure: Int
    let humidity: Int
    
    var humidityPercentage: String {
        return "\(humidity)%"
    }
    
    var pascalPressure: String {
        return "\(pressure) hPa"
    }
    
    //converting Kelvin to celsius
    var temperatureInCelsius: String {
        return "\(Int(temp) - 273) °C"
    }
}

struct Wind: Decodable {
    let speed: Float
    let deg: Float
    
    var direction: String {
        return deg.direction
    }
    
    var windSpeed: String {
        return "\(speed) m/s"
    }
}
