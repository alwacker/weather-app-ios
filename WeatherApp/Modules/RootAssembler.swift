//
//  RootAssembler.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

class RootAssembler {
    public static let instance = RootAssembler()
    let assembler: Assembler
    
    init() {
        let base = Assembler(container: AppContainer.instance.container)
        assembler = RootAssembler.registerModules(using: base)
    }
    
    //Register here your new module
    class func registerModules(using base: Assembler) -> Assembler {
        return base.withModules { context in
            context.register(AppModule.self)
            context.register(WeatherModule.self)
        }
    }
}
