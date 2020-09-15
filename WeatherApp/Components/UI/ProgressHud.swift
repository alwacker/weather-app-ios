//
//  ProgressHud.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import SVProgressHUD

private let progressDelay = 0.5

class ProgressHud: SVProgressHUD {
    static let instance = { () -> ProgressHud in
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setMinimumDismissTimeInterval(2.0)
        SVProgressHUD.setBackgroundColor(UIColor(white: 0, alpha: 0.8))
        SVProgressHUD.setForegroundColor(.white)
        return ProgressHud()
    }()
    
    override class func show() {
        DispatchQueue.main.async {
            cancelPreviousPerformRequest()
            instance.perform(#selector(performJustShow), with: nil, afterDelay: TimeInterval(progressDelay))
        }
    }
    
    @objc func performJustShow() {
        SVProgressHUD.show()
    }
    
    override class func show(withStatus status: String?) {
        cancelPreviousPerformRequest()
        instance.perform(#selector(performShow(withStatus:)), with: status, afterDelay: TimeInterval(progressDelay))
    }
    
    @objc func performShow(withStatus status: String?) {
        SVProgressHUD.show(withStatus: status)
    }
    
    override class func setStatus(_ string: String?) {
        cancelPreviousPerformRequest()
        SVProgressHUD.setStatus(string)
    }
    
    override class func showSuccess(withStatus string: String?) {
        cancelPreviousPerformRequest()
        SVProgressHUD.showSuccess(withStatus: string)
    }

    static let showErrorReplace: [String]? = {
        var replace = ["http", "[", "]", "request"]
        return replace
    }()
    
    override class func showError(withStatus string: String?) {
        self.cancelPreviousPerformRequest()
        SVProgressHUD.showError(withStatus: string)
    }
    
    class func showProgress(_ progress: CGFloat) {
        self.cancelPreviousPerformRequest()
        if SVProgressHUD.isVisible() {
            SVProgressHUD.showProgress(Float(progress))
        } else {
            instance.perform(#selector(performShowProgress(_:)),
                             with: NSNumber(value: Float(progress)),
                             afterDelay: TimeInterval(progressDelay))
        }
    }
    
    @objc func performShowProgress(_ progress: NSNumber?) {
        SVProgressHUD.showProgress(progress?.floatValue ?? 0.0)
    }
    
    override class func showInfo(withStatus status: String?) {
        cancelPreviousPerformRequest()
        SVProgressHUD.showInfo(withStatus: status)
    }
    
    static func cancelPreviousPerformRequest() {
        NSObject.cancelPreviousPerformRequests(withTarget: self.instance)
    }
    
    override static func dismiss() {
        cancelPreviousPerformRequest()
        SVProgressHUD.dismiss()
    }
}

