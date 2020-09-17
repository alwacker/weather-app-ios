//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 17/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ErrorView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var settingsButton: UIButton! {
        didSet {
            settingsButton.setTitle("SETTINGS_BTN_TITLE".localize, for: .normal)
        }
    }
    @IBOutlet private weak var tryAgainButton: UIButton! {
        didSet {
            tryAgainButton.setTitle("TRY_AGAIN_BTN".localize, for: .normal)
        }
    }
    
    private let disposeBag = DisposeBag()
    
    let tryAgainButtonPressed = PublishSubject<Void>()
    let settingsButtonPressed = PublishSubject<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: ErrorView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        tryAgainButton.rx.tap
            .bind(to: tryAgainButtonPressed)
            .disposed(by: disposeBag)
        
        settingsButton.rx.tap
            .bind(to: settingsButtonPressed)
            .disposed(by: disposeBag)
    }
    
    func setupError(with error: Error) {
        let nsError = error as NSError
        if nsError.code == 13 {
            errorLabel.text = "NO_INTERNET_CONNECTION".localize
        } else {
            errorLabel.text = "UNKNOWN_ERROR".localize
        }
        tryAgainButton.isHidden = false
        settingsButton.isHidden = true
    }
    
    func setupWarning() {
        errorLabel.text = "NO_LOCAL_ENABLED".localize
        tryAgainButton.isHidden = true
        settingsButton.isHidden = false
    }
}
