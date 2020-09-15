//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 15/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import RxSwift
import RxCocoa

class ForecastViewModel {
    //inputs
    let didLoad = PublishSubject<Void>()
    //output
    let title: Driver<String>
    
    init(service: WeatherService) {
        title = didLoad
            .mapTo("Forecast")
            .asDriver(onErrorDriveWith: .empty())
    }
}
