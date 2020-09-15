//
//  CurrentWeatherViewModel.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import RxSwift
import RxCocoa

class CurrentWeatherViewModel {
    //inputs
    let didLoad = PublishSubject<Void>()
    //outputs
    let title: Driver<String>
    
    init(service: WeatherService) {
        title = didLoad
            .mapTo("Today")
            .asDriver(onErrorDriveWith: .empty())
    }
}
