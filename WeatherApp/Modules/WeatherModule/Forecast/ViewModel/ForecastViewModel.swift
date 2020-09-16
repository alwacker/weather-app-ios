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

class ForecastViewModel {
    //inputs
    let didLoad = PublishSubject<Void>()
    let location = PublishSubject<CLLocation?>()

    //output
    let title: Driver<String>
    let sections: Driver<[Sections]>
    let disableTracking: Driver<Void>
    let hud: Driver<HudStatus>
    
    init(service: WeatherService) {
        let request = location
            .unwrap()
            .flatMapLatest(service.getForecast)
            .share()
        
        let data = request.data()
        
        disableTracking = data.toVoid()
            .asDriver(onErrorDriveWith: .empty())
        
        sections = request.data()
            .map(ForecastViewModel.sections)
            .asDriver(onErrorDriveWith: .empty())

        title = didLoad
            .mapTo("Forecast")
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
                        section: ("Today", $0.value.first?.dt_txt ?? "")
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
