//
//  AppRouter+TransitionHandler.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 17/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation
import UIKit

extension AppRouter: TransitionHandler {
    public func push(controller: UIViewController, animated: Bool) {
        let pushBlock = {
            self.show(
                controller: controller,
                options: AppRouterOptions(
                    navigation: .Push(options: .Plain, animated: animated)
                )
            )
        }
        
        if Thread.isMainThread {
            pushBlock()
        } else {
            DispatchQueue.main.sync {
                pushBlock()
            }
        }
    }
     
    public func modal(controller: UIViewController, animated: Bool) {
        let modalBlock = {
            self.show(
                controller: controller,
                options: AppRouterOptions(
                    navigation: .Dialog(options: .Plain, animated: animated)
                )
            )
        }
        if Thread.isMainThread {
            modalBlock()
        } else {
            DispatchQueue.main.sync {
                modalBlock()
            }
        }
    }
}

