//
//  WeatherRouter.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 17/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation
import UIKit

class WeatherRouter {
    private let transitionHandler: TransitionHandler
    
    init(transitionHandler: TransitionHandler) {
        self.transitionHandler = transitionHandler
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "ALERT_TITLE".localize,
            message: "ALERT_LOCATION_ERROR_MESSAGE".localize,
            preferredStyle: .alert)
        
        let settings = UIAlertAction(title: "ALERT_LOCATION_SETTINGS_TITLE".localize, style: .default) { [weak self ] _ in
            self?.showSettings()
        }
        let cancel = UIAlertAction(title: "ALERT_LOCATION_CANCEL".localize, style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(settings)
        transitionHandler.modal(controller: alert, animated: true)
    }
    
    func showSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:])
        }
    }
    
    func share(message: String) {
        let textToShare = [message]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.postToFacebook
        ]
        transitionHandler.modal(controller: activityViewController, animated: true)
    }
}
