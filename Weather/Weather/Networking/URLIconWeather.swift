//
//  URLIconWeather.swift
//  Weather
//
//  Created by Aleksey Bardin on 03.11.2020.
//

import Foundation

let testIcon = "https://n7.nextpng.com/sticker-png/533/833/sticker-png-weather-forecasting-computer-icons-android-cloudy-angle-cloud-weather-forecasting-computer-wallpaper.png"

//"https://yastatic.net/weather/i/icons/blueye/color/svg/\(withIcon).svg")

class URLIconWeather {
    func preparationURL(_ withIcon: String) -> URL? {
        guard let url = URL(string: "https://yastatic.net/weather/i/icons/blueye/color/svg/\(withIcon).svg") else {
            return nil
        }

        return url
    }
}
