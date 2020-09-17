//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 15/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreLocation
import RxCoreLocation

class ForecastViewModel {
    //inputs
    let didLoad = PublishSubject<Void>()
    let location = PublishSubject<CLLocation?>()
    let authorizationState = PublishSubject<CLAuthorizationEvent>()
    let tryAgainButtonPressed = PublishSubject<Void>()
    let settingsButtonPressed = PublishSubject<Void>()
    
    //output
    let title: Driver<String>
    let sections: Driver<[Sections]>
    let disableTracking: Driver<Void>
    let unhide: Driver<Bool>
    let tryAgain: Driver<Void>
    let authDenied: Driver<Void>
    let hide: Driver<Error>
    let hud: Driver<HudStatus>
    
    private let disposeBag = DisposeBag()
    
    init(service: WeatherService, router: WeatherRouter) {
        let request = location
            .unwrap()
            .flatMapLatest(service.getForecast)
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
        
        sections = request.data()
            .map(ForecastViewModel.sections)
            .asDriver(onErrorDriveWith: .empty())

        title = didLoad
            .mapTo("FORECAST_TITLE".localize)
            .asDriver(onErrorDriveWith: .empty())
        
        hud = HudStatus.merge(request.hud())
    }
    
    private static func sections(with entity: ForecastEntity) -> [Sections] {
        var sections = [Sections]()
        let dictionary = Dictionary(grouping: entity.list, by: { $0.dateId } )
        let sortedDictionary = dictionary.sorted { $0.key < $1.key }
        sortedDictionary.forEach {
            let todayDay = Date().dayOfWeek
            let items = $0.value.map { SectionItem.weatherItem(weather: $0) }
            if todayDay == $0.key.formatDate.dayOfWeek {
                sections.append(.daySection(items: [.daySection(
                        section: ("TODAY_TITLE".localize, $0.value.first?.dt_txt ?? "")
                    )
                ]))
            } else {
                sections.append(.daySection(items: [.daySection(
                        section: ($0.key.formatDate.dayOfWeek, $0.value.first?.dt_txt ?? "")
                    )
                ]))
            }
            sections.append(.weatherItem(items: items))
        }
        return sections
    }
}
