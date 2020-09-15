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
    
    public func createTabbar() -> UIViewController {
        let tabBarVC = UITabBarController()
        let weatherSection = showCurrentWeatherSection()
        let forecastSection = showForecastSection()
        weatherSection.tabBarItem = UITabBarItem(title: "Today", image: #imageLiteral(resourceName: "today_inactive_icon"), selectedImage: #imageLiteral(resourceName: "today_active_icon"))
        forecastSection.tabBarItem = UITabBarItem(title: "Forecast", image: #imageLiteral(resourceName: "forecast_inactive_icon"), selectedImage: #imageLiteral(resourceName: "forecast_active_icon"))
        tabBarVC.viewControllers = [weatherSection, forecastSection]
        return tabBarVC
    }
    
    private func showCurrentWeatherSection() -> UIViewController {
        let vc = assembler
            .with(assemblies: CurrentWeatherViewAssembly())
            .resolver
            .resolve(CurrentWeatherViewController.self)!
        
        let root = NavigationViewController(rootViewController: vc)
        return root
    }
    
    private func showForecastSection() -> UIViewController {
        let vc = assembler
            .with(assemblies: ForecastViewAssembly())
            .resolver
            .resolve(ForecastViewController.self)!
        let root = NavigationViewController(rootViewController: vc)
        return root
    }
}
