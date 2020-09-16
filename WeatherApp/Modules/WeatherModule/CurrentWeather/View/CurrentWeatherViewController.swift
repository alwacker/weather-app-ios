//
//  CurrentWeatherViewController.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxCoreLocation
import CoreLocation

class CurrentWeatherViewController: BaseViewController {
    @IBOutlet private weak var conditionIcon: UIImageView!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var precipitationLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var windDirectionLabel: UILabel!
    @IBOutlet private weak var locationIcon: UIImageView!
    @IBOutlet private weak var higherDivider: UIImageView!
    @IBOutlet private weak var lowerDivider: UIImageView!
    @IBOutlet private weak var humidityIcon: UIImageView!
    @IBOutlet private weak var precipitationIcon: UIImageView!
    @IBOutlet private weak var pressureIcon: UIImageView!
    @IBOutlet private weak var windIcon: UIImageView!
    @IBOutlet private weak var windDirectionIcon: UIImageView!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var errorView: ErrorView!
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.refreshControl = UIRefreshControl()
            scrollView.refreshControl?.addTarget(
                self,
                action: #selector(handleRefreshControl),
                for: .valueChanged
            )
        }
    }
    
    private let viewModel: CurrentWeatherViewModel
    private let disposeBag = DisposeBag()
    private let manager: CLLocationManager
    
    init(viewModel: CurrentWeatherViewModel) {
        self.viewModel = viewModel
        self.manager = CLLocationManager()
        super.init(nibName: "CurrentWeatherViewController", bundle: nil)
        
        rx.viewDidLoad
            .bind(to: viewModel.didLoad)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.requestWhenInUseAuthorization()
        updateLocation()
        setupBinding()
    }
    
    private func hideUI(with error: Error) {
        scrollView.isHidden = true
        errorView.isHidden = false
        errorView.setupUI(with: "")
    }
    
    private func showUI(if hidden: Bool) {
        scrollView.isHidden = hidden
        errorView.isHidden = !hidden
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.conditionIcon.isHidden = hidden
            self.cityLabel.isHidden = hidden
            self.temperatureLabel.isHidden = hidden
            self.humidityLabel.isHidden = hidden
            self.precipitationLabel.isHidden = hidden
            self.pressureLabel.isHidden = hidden
            self.windLabel.isHidden = hidden
            self.windDirectionLabel.isHidden = hidden
            self.locationIcon.isHidden = hidden
            self.higherDivider.isHidden = hidden
            self.lowerDivider.isHidden = hidden
            self.humidityIcon.isHidden = hidden
            self.precipitationIcon.isHidden = hidden
            self.pressureIcon.isHidden = hidden
            self.windIcon.isHidden = hidden
            self.windDirectionIcon.isHidden = hidden
            self.shareButton.isHidden = hidden
        })
    }
    
    @objc private func handleRefreshControl() {
        updateLocation()
        DispatchQueue.main.async { [weak self] in
            self?.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    private func updateLocation() {
        manager.startUpdatingLocation()
    }
    
    private func setupBinding() {
        viewModel.unhide
            .drive(
                onNext: { [weak self] in
                    self?.showUI(if: $0)
                }
        ).disposed(by: disposeBag)
        
        viewModel.disableTracking
            .drive(
                onNext: { [weak self] in
                    self?.manager.stopUpdatingLocation()
                }
        ).disposed(by: disposeBag)
        
        viewModel.tryAgain
            .drive(
                onNext: { [weak self] in
                    self?.updateLocation()
                }
        ).disposed(by: disposeBag)
        
        viewModel.hide.drive(
            onNext: { [weak self] in
                self?.hideUI(with: $0)
            }
        ).disposed(by: disposeBag)
        
        viewModel.humidity
            .drive(humidityLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.pressure
            .drive(pressureLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.windDirection
            .drive(windDirectionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.windSpeed
            .drive(windLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.precipitation
            .drive(precipitationLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.city
            .drive(cityLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.icon
            .drive(conditionIcon.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.conditionsText
            .drive(temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        manager.rx.location
            .bind(to: viewModel.location)
            .disposed(by: disposeBag)
        
        manager.rx.didChangeAuthorization
            .bind(to: viewModel.authorizationState)
            .disposed(by: disposeBag)
        
        viewModel.title
            .drive(rx.title)
            .disposed(by: disposeBag)
        
        ProgressHud.rx
            .observe(status: viewModel.hud)
            .disposed(by: disposeBag)
    }
}
