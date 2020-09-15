//
//  Module.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

public protocol Module {
    init(assembler: Assembler)
    func loaded()
}

extension Module {
    public func loaded() {
        //NOP
    }
}

class ModuleRegistrationContext {
    fileprivate var assemblies = [Assembly]()
    fileprivate var resolves = [(Assembler) -> ()]()
    fileprivate var modules = [Module]()
    
    public func register<T: Module>(_ module: T.Type) {
        assemblies.append(ModuleAssembly(module: module))
        resolves.append { assembler in
            let module = assembler.resolver.resolve(T.self)!
            self.modules.append(module)
        }
    }
}

extension Assembler {
    func withModules(_ register: (_ context: ModuleRegistrationContext) -> ()) -> Assembler {
        let context = ModuleRegistrationContext()
        register(context)
        let assembler = Assembler(context.assemblies, parent: self).registerSelf()
        context.resolves.forEach {
            $0(assembler)
        }
        context.modules.forEach {
            $0.loaded()
        }
        return assembler
    }
}

class ModuleAssembly<T: Module>: Assembly {
    let module: T.Type
    init(module: T.Type) {
        self.module = module
    }
    public func assemble(container: Container) {
        container
            .autoregister(module.self, initializer: module.init)
            .inObjectScope(.container)
    }
}

