//
//  WeatherListTableViewCell.swift
//  Weather
//
//  Created by Aleksey Bardin on 30.10.2020.
//

import UIKit
import MapKit

final class WeatherListTableViewCell: UITableViewCell {

    @IBOutlet var city: UILabel! {
        willSet {
            newValue.font = Fonts.labelFont
        }
    }
    
    @IBOutlet var temperature: UILabel! {
        willSet {
            newValue.font = Fonts.labelFont
        }
    }

    @IBOutlet var conditionImage: UIImageView!


    func displayResult(_ result: MKLocalSearchCompletion) {
            city.text = String(result.title.prefix(while: { $0 != "," }))
    }
    
}
