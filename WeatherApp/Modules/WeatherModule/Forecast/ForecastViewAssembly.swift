//
//  ForecastViewAssembly.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 15/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

internal class ForecastViewAssembly: Assembly {
    func assemble(container: Container) {
        container
            .autoregister(ForecastViewModel.self, initializer: ForecastViewModel.init)
        container
            .autoregister(ForecastViewController.self, initializer: ForecastViewController.init)
        container
            .autoregister(WeatherRouter.self, initializer: WeatherRouter.init)
    }
}
