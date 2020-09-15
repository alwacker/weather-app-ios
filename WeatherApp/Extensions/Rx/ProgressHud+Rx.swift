//
//  ProgressHud+Rx.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: ProgressHud {
    static func observe(status: Driver<HudStatus>) -> Disposable {
        guard Thread.isMainThread else {
            return DispatchQueue.main.sync {
                return observe(status: status)
            }
        }
        return status.drive(onNext: { status in
            switch status {
            case .loading: ProgressHud.show()
            case .loaded: ProgressHud.dismiss()
            case .success(let message): ProgressHud.showSuccess(withStatus: message)
            case .error(let message): ProgressHud.showError(withStatus: message)
            case .info(let message): ProgressHud.showInfo(withStatus: message)
            }
        })
    }
}
