//
//  URLIconWeather.swift
//  Weather
//
//  Created by Aleksey Bardin on 03.11.2020.
//

import Foundation

class URLIconWeather {
    func preparationURL(_ withIcon: String) -> URL? {
        guard let url = URL(string: "https://yastatic.net/weather/i/icons/blueye/color/svg/\(withIcon).svg") else {
            return nil
        }

        return url
    }
}
