//
//  AppRouterAssembly.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

internal class AppRouterAssembly: Assembly {
    func assemble(container: Container) {
        container
            .autoregister(AppRouter.self, initializer: AppRouter.init)
            .inObjectScope(.container)
    }
}
