//
//  CurrentWeatherViewModel.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreLocation

class CurrentWeatherViewModel {
    //inputs
    let didLoad = PublishSubject<Void>()
    let location = PublishSubject<CLLocation?>()
    //outputs
    let title: Driver<String>
    let conditionsText: Driver<String>
    let icon: Driver<UIImage?>
    let city: Driver<String>
    let humidity: Driver<String>
    let precipitation: Driver<String>
    let pressure: Driver<String>
    let windSpeed: Driver<String>
    let windDirection: Driver<String>
    let disableTracking: Driver<Void>
    let unhide: Driver<Bool>
    let hud: Driver<HudStatus>
    
    init(service: WeatherService) {
        let request = location.unwrap()
            .flatMapLatest(service.getCurrentWeather)
            .share()
        
        let data = request.data()
        
        unhide = data.mapTo(false)
            .asDriver(onErrorDriveWith: .empty())
        
        disableTracking = data.toVoid()
            .asDriver(onErrorDriveWith: .empty())
        
        //A little hack, cause this value not going from BE
        precipitation = didLoad
            .mapTo("n/a")
            .asDriver(onErrorDriveWith: .empty())
        
        windSpeed = data
            .map { $0.wind.windSpeed }
            .asDriver(onErrorDriveWith: .empty())
        
        windDirection = data
            .map { $0.wind.direction }
            .asDriver(onErrorDriveWith: .empty())

        pressure = data
            .map { $0.main.pascalPressure }
            .asDriver(onErrorDriveWith: .empty())

        humidity = data
            .map { $0.main.humidityPercentage }
            .asDriver(onErrorDriveWith: .empty())

        city = data
            .map { $0.fullNameLocation }
            .asDriver(onErrorDriveWith: .empty())
        
        icon = data
            .map { $0.weather.first?.truncateDescription }
            .unwrap()
            .map { UIImage(named: $0) }
            .asDriver(onErrorDriveWith: .empty())
        
        conditionsText = data
            .map { "\($0.main.temperatureInCelsius) | \($0.weather.first?.main.capitalized ?? "")" }
            .asDriver(onErrorDriveWith: .empty())
        
        title = didLoad
            .mapTo("Today")
            .asDriver(onErrorDriveWith: .empty())
        
        hud = HudStatus.merge(request.hud())
    }
}
