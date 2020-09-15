//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import RxSwift
import CoreLocation

class WeatherService {
    
    private let api: WeatherApi
    
    init(api: WeatherApi) {
        self.api = api
    }
    
    func getCurrentWeather(with location: CLLocation) -> Observable<ApiEvent<CurrentWeather>>{
        return api.getCurrentWeather(
            with: location.coordinate.latitude.magnitude,
            longtitude: location.coordinate.longitude.magnitude
        )
    }
    
}
