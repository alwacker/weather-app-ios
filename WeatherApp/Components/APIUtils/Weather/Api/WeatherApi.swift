//
//  WeatherApi.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 15/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation
import RxSwift

private let apiKey = "1ed68e89eb8ef4c76b05d86cb7600ab7"

class WeatherApi: BaseApi {
    func getCurrentWeather(with latitude: Double, longtitude: Double) -> Observable<ApiEvent<CurrentWeather>> {
        let endPoint = String(format: ApiEndPoint.currentWeather.rawValue, latitude, longtitude, apiKey)
        return request(endPoint: endPoint)
    }
    
    func getForecast(with latitude: Double, longtitude: Double) -> Observable<ApiEvent<ForecastEntity>> {
        let endPoint = String(format: ApiEndPoint.forecast.rawValue, latitude, longtitude, apiKey)
        return request(endPoint: endPoint)
    }
}
