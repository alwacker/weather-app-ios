//
//  AppContainer.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

class AppContainer {
    static let instance = AppContainer()
    let container = Container()
    
    init() {
        container.register(Resolver.self) { resolver in
            return resolver
        }
        
        container.register(Gateway.self) { resolver in
            return resolver.resolve(Gateway.self)!
        }
        
        container.register(ApiGateway.self) { resolver in
            return ApiGateway(baseUrl: "https://www.alza.cz/Services/RestService.svc")
        }
    }
}
