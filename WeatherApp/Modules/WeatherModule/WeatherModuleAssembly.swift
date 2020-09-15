//
//  WeatherModuleAssembly.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 15/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

internal class WeatherModuleAssembly: Assembly {
    func assemble(container: Container) {
        container
            .autoregister(WeatherService.self, initializer: WeatherService.init)
        container
            .autoregister(WeatherApi.self, initializer: WeatherApi.init(base:))
    }
}
