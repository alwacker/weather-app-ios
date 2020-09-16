//
//  SceneDelegate.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import UIKit

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        appDelegate?.window = self.window
        let appModule = AppModule(assembler: RootAssembler.instance.assembler)
        window?.rootViewController = appModule.router.initialize()
        window?.makeKeyAndVisible()
    }
}
