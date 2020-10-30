//
//  WeatherListTableViewCell.swift
//  Weather
//
//  Created by Aleksey Bardin on 30.10.2020.
//

import UIKit

class WeatherListTableViewCell: UITableViewCell {

    @IBOutlet var city: UILabel!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var conditionImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
