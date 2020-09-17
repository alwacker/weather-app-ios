//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 16/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {
    @IBOutlet weak var forecastIcon: UIImageView!
    @IBOutlet weak var timePredictionLabel: UILabel!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timePredictionLabel.text = nil
        predictionLabel.text = nil
        temperatureLabel.text = nil
        forecastIcon.image = nil
    }
    
    func setupUI(with weatherItem: WeatherItem) {
        forecastIcon.image = UIImage(named: weatherItem.weather.first?.truncateDescription ?? "")
        timePredictionLabel.text = weatherItem.time
        predictionLabel.text = weatherItem.weather.first?.description.capitalized
        temperatureLabel.text = weatherItem.main.temperatureInCelsius
    }
    
}
