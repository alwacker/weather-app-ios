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
import RxCoreLocation

class CurrentWeatherViewModel {
    //inputs
    let didLoad = PublishSubject<Void>()
    let location = PublishSubject<CLLocation?>()
    let authorizationState = PublishSubject<CLAuthorizationEvent>()
    let tryAgainButtonPressed = PublishSubject<Void>()
    let settingsButtonPressed = PublishSubject<Void>()
    let shareButtonPressed = PublishSubject<Void>()
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
    let tryAgain: Driver<Void>
    let authDenied: Driver<Void>
    let hide: Driver<Error>
    let hud: Driver<HudStatus>
    
    private let disposeBag = DisposeBag()
    
    init(service: WeatherService, router: WeatherRouter) {
        let request = location.unwrap()
            .flatMapLatest(service.getCurrentWeather)
            .share()
        
        let data = request.data()
        let error = request.errors()
        
        hide = error
            .asDriver(onErrorDriveWith: .empty())
        
        unhide = data.mapTo(false)
            .asDriver(onErrorDriveWith: .empty())
        
        disableTracking = Observable
            .merge(data.toVoid(), error.toVoid())
            .asDriver(onErrorDriveWith: .empty())
        
        let authorized = authorizationState
            .filter { $0.1 == .authorizedAlways || $0.1 == .authorizedWhenInUse }
            .toVoid()
        
        let deniedAuthorization = authorizationState
            .filter { $0.1 == .denied }
            .toVoid()
        
        tryAgain = Observable.merge(tryAgainButtonPressed, authorized)
            .asDriver(onErrorDriveWith: .empty())
        
        deniedAuthorization
            .subscribe(onNext: router.showAlert)
            .disposed(by: disposeBag)
        
        settingsButtonPressed
            .subscribe(onNext: router.showSettings)
            .disposed(by: disposeBag)
        
        authDenied = deniedAuthorization
            .asDriver(onErrorDriveWith: .empty())
        
        shareButtonPressed
            .withLatestFrom(data)
            .map { String(
                format: "SHARE_MESSAGE".localize,
                $0.fullNameLocation,
                $0.main.temperatureInCelsius,
                $0.weather.first?.description.capitalized ?? "")
            }.subscribe(onNext: router.share)
            .disposed(by: disposeBag)
        
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
            .mapTo("TODAY_TITLE".localize)
            .asDriver(onErrorDriveWith: .empty())
        
        hud = HudStatus.merge(request.hud())
    }
}
