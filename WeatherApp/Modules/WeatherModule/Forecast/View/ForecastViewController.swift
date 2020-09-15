//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 15/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ForecastViewController: UIViewController {
    private let viewModel: ForecastViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ForecastViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ForecastViewController", bundle: nil)
        
        rx.viewDidLoad
            .bind(to: viewModel.didLoad)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    
    private func setupBinding() {
        viewModel.title
            .drive(rx.title)
            .disposed(by: disposeBag)
    }
}
