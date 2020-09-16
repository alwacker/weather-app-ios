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
    @IBOutlet private weak var tryAgainButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    let buttonPressed = PublishSubject<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        tryAgainButton.rx.tap
            .bind(to: buttonPressed)
            .disposed(by: disposeBag)
    }
    
    func setupUI(with errorMessage: String) {
        errorLabel.text = errorMessage
    }
}
