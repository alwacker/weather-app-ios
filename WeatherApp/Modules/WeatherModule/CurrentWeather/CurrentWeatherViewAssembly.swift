//
//  CurrentWeatherViewAssembly.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

internal class CurrentWeatherViewAssembly: Assembly {
    func assemble(container: Container) {
        container
            .autoregister(CurrentWeatherViewModel.self, initializer: CurrentWeatherViewModel.init)
        container
            .autoregister(CurrentWeatherViewController.self, initializer: CurrentWeatherViewController.init)
        container
            .autoregister(WeatherRouter.self, initializer: WeatherRouter.init)
    }
}
