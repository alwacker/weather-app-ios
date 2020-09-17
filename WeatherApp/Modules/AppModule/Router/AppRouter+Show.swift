//
//  AppRouter+Show.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 17/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation
import UIKit

extension AppRouter {
    public func show(controller: UIViewController, options: AppRouterOptions) {
        guard Thread.isMainThread else {
            DispatchQueue.main.sync {
                self.show(controller: controller, options: options)
            }
            return
        }
        
        switch options.navigation {
        case .Push(let type, let animated):
            handlePushNavigation(with: type, animated: animated, controller: controller)
        case .Modal(let options, let animated, _ , let preferredContentSize):
            controller.modalPresentationStyle = .fullScreen
            if let size = preferredContentSize {
                controller.preferredContentSize = size
            }
            switch options {
            case .Navigation:
                Navigator.showModalViewController(controller, inNavigationController: true, animated: animated)
            case .Plain:
                Navigator.showModalViewController(controller, inNavigationController: false, animated: animated)
            }
        case .Dialog(let options, let animated):
            switch options {
            case .Navigation:
                Navigator.showModalViewController(controller, inNavigationController: true, animated: animated)
            case .Plain:
                Navigator.showModalViewController(controller, inNavigationController: false, animated: animated)
            }
        }
    }
    
    private func handlePushNavigation(with type: AppRouterOptions.NavigationType.PushOptions, animated: Bool, controller: UIViewController) {
        switch type {
        case .Plain:
            break
        case .ResetHistory:
            Navigator.rootViewController?.navigationController?.popToRootViewController(animated: false)
        case .ReplaceLastItem:
            Navigator.rootViewController?.navigationController?.popViewController(animated: true)
        }
        
        if let navController = Navigator.rootViewController?.presentedViewController as? NavigationViewController,
            !navController.viewControllers.isEmpty,
            let vc = navController.viewControllers.first {
            vc.push(controller: controller, animated: true)
        } else {
            let navigationController = Navigator
                .getRootNavigationViewController(rootController: controller)
            
            navigationController
                .presentedViewController?
                .dismiss(animated: true, completion: nil)
            
            navigationController.pushViewController(controller, animated: animated)
        }
    }
}
