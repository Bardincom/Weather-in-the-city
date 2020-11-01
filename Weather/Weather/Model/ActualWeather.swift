//
//  ActualWeather.swift
//  Weather
//
//  Created by Aleksey Bardin on 31.10.2020.
//

import Foundation

struct ActualWeather: Codable {
    var temperature: Int
    var feelsTemperature: Int
    var iconWeather: String
    var condition: String


    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsTemperature = "feels_like"
        case iconWeather = "icon"
        case condition
    }
}
