//
//  ApiEndPoint.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation


public enum ApiEndPoint: String {
    case currentWeather = "/data/2.5/weather?lat=%f&lon=%f&appid=%@"
}
