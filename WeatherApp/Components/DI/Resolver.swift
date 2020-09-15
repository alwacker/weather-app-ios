//
//  Resolver.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

extension Resolver {
    public func resolve<T>() -> T? {
        return self.resolve(T.self)
    }
}

extension Assembler {
    
    public func with(assemblies: Assembly...) -> Assembler {
        return Assembler(assemblies, parent: self)
    }
    
    public func with(assemblies: [Assembly]) -> Assembler {
        return Assembler(assemblies, parent: self)
    }
    
    public func with<Arg1>(globals arg1: Arg1) -> Assembler {
        return Assembler([
            GlobalsAssembly1(arg1)
            ], parent: self)
    }
    
    public func with<Arg1, Arg2>(globals arg1: Arg1, _ arg2: Arg2) -> Assembler {
        return Assembler([
            GlobalsAssembly2(arg1, arg2)
            ], parent: self)
    }
    
    public func with<Arg1, Arg2, Arg3>(globals arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> Assembler {
        return Assembler([
            GlobalsAssembly3(arg1, arg2, arg3)
            ], parent: self)
        
    }
    
    public func with<Arg1, Arg2, Arg3, Arg4>(globals arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> Assembler {
        return Assembler([
            GlobalsAssembly4(arg1, arg2, arg3, arg4)
            ], parent: self)
    }
    
}

fileprivate class GlobalsAssembly1<Arg1>: Assembly {
    private let arg1: Arg1
    
    init(_ arg1: Arg1) {
        self.arg1 = arg1
    }
    
    func assemble(container: Container) {
        let arg1 = self.arg1
        container.register(Arg1.self) { _ in return arg1 }.inObjectScope(.container)
    }
}

fileprivate class GlobalsAssembly2<Arg1, Arg2>: Assembly {
    private let arg1: Arg1
    private let arg2: Arg2
    
    init(_ arg1: Arg1, _ arg2: Arg2) {
        self.arg1 = arg1
        self.arg2 = arg2
    }
    
    func assemble(container: Container) {
        let arg1 = self.arg1
        let arg2 = self.arg2
        container.register(Arg1.self) { _ in return arg1 }.inObjectScope(.container)
        container.register(Arg2.self) { _ in return arg2 }.inObjectScope(.container)
    }
}

fileprivate class GlobalsAssembly3<Arg1, Arg2, Arg3> : Assembly {
    private let arg1: Arg1
    private let arg2: Arg2
    private let arg3: Arg3
    
    init(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) {
        self.arg1 = arg1
        self.arg2 = arg2
        self.arg3 = arg3
    }
    
    func assemble(container: Container) {
        let arg1 = self.arg1
        let arg2 = self.arg2
        let arg3 = self.arg3
        container.register(Arg1.self) { _ in return arg1 }.inObjectScope(.container)
        container.register(Arg2.self) { _ in return arg2 }.inObjectScope(.container)
        container.register(Arg3.self) { _ in return arg3 }.inObjectScope(.container)
    }
}

fileprivate class GlobalsAssembly4<Arg1, Arg2, Arg3, Arg4> : Assembly {
    private let arg1: Arg1
    private let arg2: Arg2
    private let arg3: Arg3
    private let arg4: Arg4
    
    init(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) {
        self.arg1 = arg1
        self.arg2 = arg2
        self.arg3 = arg3
        self.arg4 = arg4
    }
    
    func assemble(container: Container) {
        let arg1 = self.arg1
        let arg2 = self.arg2
        let arg3 = self.arg3
        let arg4 = self.arg4
        container.register(Arg1.self) { _ in return arg1 }.inObjectScope(.container)
        container.register(Arg2.self) { _ in return arg2 }.inObjectScope(.container)
        container.register(Arg3.self) { _ in return arg3 }.inObjectScope(.container)
        container.register(Arg4.self) { _ in return arg4 }.inObjectScope(.container)
    }
}

extension Assembler {
    @discardableResult
    public func registerSelf() -> Assembler {
        self.apply(assembly: AssemblerSelf(assembler: self))
        return self
    }
}

fileprivate class AssemblerSelf: Assembly {
    private let assembler: Assembler
    init(assembler: Assembler) {
        self.assembler = assembler
    }
    
    func assemble(container: Container) {
        let assembler: Assembler = self.assembler
        container.register(Assembler.self) { _ in
            return assembler
        }
    }
}
