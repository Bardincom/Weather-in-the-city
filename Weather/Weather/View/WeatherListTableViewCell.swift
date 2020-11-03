//
//  WeatherListTableViewCell.swift
//  Weather
//
//  Created by Aleksey Bardin on 30.10.2020.
//

import UIKit
import MapKit

final class WeatherListTableViewCell: UITableViewCell {

    @IBOutlet private var location: UILabel! {
        willSet {
            newValue.font = Fonts.labelFont
        }
    }
    
    @IBOutlet private var temperature: UILabel! {
        willSet {
            newValue.font = Fonts.degreesFont
        }
    }

    @IBOutlet private var conditionImage: UIImageView!

    private let urlIcon = URLIconWeather()

    func displayFavoriteLocation(_ favoriteLocation: Location) {
        temperature.isHidden = false
        conditionImage.isHidden = false

        location.text = favoriteLocation.name
        temperature.text = String(favoriteLocation.actualWeather.temperature) + Text.degrees

        guard let url = urlIcon.preparationURL(favoriteLocation.actualWeather.iconWeather) else { return }

        let processor = SVGProcessor(size: CGSize(width: conditionImage.frame.width, height: conditionImage.frame.height))
        conditionImage.kf.setImage(with: url, options: [.processor(processor)])
    }

    func displayResultSearchLocation(_ result: MKLocalSearchCompletion) {
        location.text = String(result.title)
        temperature.isHidden = true
        conditionImage.isHidden = true
    }


    
}
