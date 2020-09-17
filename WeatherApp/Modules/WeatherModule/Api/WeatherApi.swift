//
//  WeatherApi.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 15/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation
import RxSwift

class WeatherApi: BaseApi {
    func getCurrentWeather(with latitude: Double, longtitude: Double) -> Observable<ApiEvent<CurrentWeather>> {
        let endPoint = String(format: ApiEndPoint.currentWeather.rawValue, latitude, longtitude, Constants.apiKey)
        return request(endPoint: endPoint)
    }
    
    func getForecast(with latitude: Double, longtitude: Double) -> Observable<ApiEvent<ForecastEntity>> {
        let endPoint = String(format: ApiEndPoint.forecast.rawValue, latitude, longtitude, Constants.apiKey)
        return request(endPoint: endPoint)
    }
}
