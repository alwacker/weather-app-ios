//
//  CurrentWeatherModule.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Swinject

class WeatherModule: Module {
    private let assembler: Assembler
    
    required init(assembler: Assembler) {
        self.assembler = assembler.with(assemblies: WeatherModuleAssembly())
    }
    
    public func createTabbar(with transitionHandler: TransitionHandler) -> UIViewController {
        let tabBarVC = UITabBarController()
        let weatherSection = showCurrentWeatherSection(with: transitionHandler)
        let forecastSection = showForecastSection(with: transitionHandler)
        weatherSection.tabBarItem = UITabBarItem(
            title: "TODAY_TITLE".localize,
            image: #imageLiteral(resourceName: "today_inactive_icon"),
            selectedImage: #imageLiteral(resourceName: "today_active_icon")
        )
        forecastSection.tabBarItem = UITabBarItem(
            title: "FORECAST_TITLE".localize,
            image: #imageLiteral(resourceName: "forecast_inactive_icon"),
            selectedImage: #imageLiteral(resourceName: "forecast_active_icon")
        
        )
        tabBarVC.viewControllers = [weatherSection, forecastSection]
        return tabBarVC
    }
    
    private func showCurrentWeatherSection(with transitionHandler: TransitionHandler) -> UIViewController {
        let vc = assembler
            .with(assemblies: CurrentWeatherViewAssembly())
            .with(globals: transitionHandler)
            .resolver
            .resolve(CurrentWeatherViewController.self)!
        
        let root = NavigationViewController(rootViewController: vc)
        return root
    }
    
    private func showForecastSection(with transitionHandler: TransitionHandler) -> UIViewController {
        let vc = assembler
            .with(assemblies: ForecastViewAssembly())
            .with(globals: transitionHandler)
            .resolver
            .resolve(ForecastViewController.self)!
        let root = NavigationViewController(rootViewController: vc)
        return root
    }
}
