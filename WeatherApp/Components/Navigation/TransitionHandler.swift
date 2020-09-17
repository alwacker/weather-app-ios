//
//  TransitionHandler.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 17/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation
import UIKit

public protocol TransitionHandler {
    func push(controller: UIViewController, animated: Bool)
    func modal(controller: UIViewController, animated: Bool)
}

extension UIViewController: TransitionHandler {
    public func modal(controller: UIViewController, animated: Bool) {
        present(controller, animated: animated, completion: nil)
    }
    
    public func push(controller: UIViewController, animated: Bool) {
        navigationController?.pushViewController(controller, animated: animated)
    }
}
