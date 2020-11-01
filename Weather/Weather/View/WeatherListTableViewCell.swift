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
//    private let networkService = NetworkService()


    func displayFavoriteCity(_ favoriteCity: CityInfo) {
        temperature.isHidden = false
        conditionImage.isHidden = false

        city.text = favoriteCity.name
        temperature.text = String(favoriteCity.actualWeather.temperature)
    }

    func displayResultSearchCities(_ result: MKLocalSearchCompletion) {
        city.text = String(result.title)
        temperature.isHidden = true
        conditionImage.isHidden = true
    }


    
}
