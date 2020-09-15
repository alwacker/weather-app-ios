//
//  AppModule.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Swinject

class AppModule: Module {
    internal let assembler: Assembler
    
    required init(assembler: Assembler) {
        self.assembler = assembler
            .with(globals: Bundle.main)
    }
    
    lazy var router: AppRouter = {
        return self.assembler
            .with(assemblies: AppRouterAssembly())
            .resolver
            .resolve(AppRouter.self)!
    }()
}
