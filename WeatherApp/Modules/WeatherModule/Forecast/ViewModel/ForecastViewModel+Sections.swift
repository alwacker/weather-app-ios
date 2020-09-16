//
//  ForecastViewModel+Sections.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 16/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation
import RxDataSources

extension ForecastViewModel {
    typealias SectionDTO = (title: String, date: String)
    
    enum SectionItem: IdentifiableType, Equatable {
        static func == (lhs: SectionItem, rhs: SectionItem) -> Bool {
            switch (lhs, rhs) {
            case (.weatherItem(let l), .weatherItem(let r)):
                return l == r
            case (.daySection(let l), .daySection(let r)):
                return l.0.elementsEqual(r.0) && l.1.elementsEqual(r.1)
            default:
                return false
            }
        }
        
        case weatherItem(weather: WeatherItem)
        case daySection(section: SectionDTO)
        
        var identity: String {
            switch self {
            case .weatherItem(let item):
                return "The weather time is \(item.dt_txt)"
            case .daySection(let dto):
                return "Weather for \(dto.title) in \(dto.date)"
            }
        }
    }

    enum Sections: SectionModelType {
        typealias Item = SectionItem
        
        case weatherItem(items: [Item])
        case daySection(items: [Item])
        
        var items: [Item] {
            switch self {
            case .weatherItem(let items):
                return items
            case .daySection(let items):
                return items
            }
        }
        
        init(original: Sections, items: [Item]) {
            switch original {
            case .daySection:
                self = .daySection(items: items)
            case .weatherItem:
                self = .weatherItem(items: items)
            }
        }
    }
}
