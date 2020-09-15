//
//  ApiEvent+Rx.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import RxSwift
import RxSwiftExt

protocol ApiEventConvertible {
    associatedtype Data
    var value: ApiEvent<Data> { get }
}

extension ApiEvent: ApiEventConvertible {
    public typealias Data = T
    public var value: ApiEvent<Data> { return self }
}

extension ObservableType where Element: ApiEventConvertible, Element.Data: Any {
    
    func isLoading() -> Observable<Bool> {
        return self.map { $0.value.isLoading ? true : false }
    }
    
    func errors() -> Observable<Error> {
        return map { $0.value.error }.unwrap()
    }
    
    func elements(onErrorJustReturn: Element.Data? = nil) -> Observable<Element.Data> {
        return map { event -> Element.Data? in
            if event.value.isError, let value = onErrorJustReturn {
                return value
            } else {
                return event.value.loaded
            }
        }
        .unwrap()
    }
    
    //Back compatibility
    func data() -> Observable<Element.Data> {
        return elements()
    }
}
