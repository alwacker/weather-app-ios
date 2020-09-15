//
//  AppRouter.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import RxSwift
import Swinject
import UIKit

class AppRouter {
    private let resolver: Resolver

    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    private func getWeatherModule() -> UIViewController {
        let module = resolver.resolve(WeatherModule.self)!
        return module.createTabbar()
    }
  
    
    public func initialize() -> UIViewController {
        #if targetEnvironment(macCatalyst)
            return getCurrentWeatherScreen()
        
        #else
        return getWeatherModule()
        #endif
    }
}