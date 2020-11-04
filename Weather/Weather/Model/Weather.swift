//
//  Weather.swift
//  Weather
//
//  Created by Aleksey Bardin on 31.10.2020.
//

import Foundation

struct WeatherModel: Codable {
    var actualWeather: ActualWeather
    var coordinate: Coordinate

    enum CodingKeys: String, CodingKey {
        case actualWeather = "fact"
        case coordinate = "info"
    }
}
