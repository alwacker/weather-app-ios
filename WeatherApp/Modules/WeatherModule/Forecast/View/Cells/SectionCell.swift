//
//  SectionCell.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 16/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import UIKit

class SectionCell: UITableViewCell {
    
    @IBOutlet private weak var sectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }
    
    func setupUI(with title: String) {
        sectionLabel.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sectionLabel.text = nil
    }
}
