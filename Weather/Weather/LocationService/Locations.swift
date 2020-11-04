//
//  Locations.swift
//  Weather
//
//  Created by Aleksey Bardin on 04.11.2020.
//

import Foundation

struct Locations {
    static var locations: [Location] = [
        Location(name: "Москва",
                 actualWeather: ActualWeather(temperature: 0, feelsTemperature: 0, iconWeather: "bkn_d", condition: ""),
                 coordinate: Coordinate(latitude: 55.7615902, longitude: 37.60946),
                 isFavorite: true),

        Location(name: "Санкт-Петербург",
                 actualWeather: ActualWeather(temperature: 0, feelsTemperature: 0, iconWeather: "bkn_d", condition: ""),
                 coordinate: Coordinate(latitude: 59.9342562, longitude: 30.3351228),
                 isFavorite: true),

        Location(name: "Миссури",
                 actualWeather: ActualWeather(temperature: 0, feelsTemperature: 0, iconWeather: "bkn_d", condition: ""),
                 coordinate: Coordinate(latitude: 38.4627673, longitude: -92.5745335),
                 isFavorite: true),

        Location(name: "Киев",
                 actualWeather: ActualWeather(temperature: 0, feelsTemperature: 0, iconWeather: "bkn_d", condition: ""),
                 coordinate: Coordinate(latitude: 50.4501, longitude: 30.5234),
                 isFavorite: true),

        Location(name: "Барроу",
                 actualWeather: ActualWeather(temperature: 0, feelsTemperature: 0, iconWeather: "bkn_d", condition: ""),
                 coordinate: Coordinate(latitude: 71.2991259, longitude: -156.7578454),
                 isFavorite: true),

        Location(name: "Пасадена",
                 actualWeather: ActualWeather(temperature: 0, feelsTemperature: 0, iconWeather: "bkn_d", condition: ""),
                 coordinate: Coordinate(latitude: 34.147643, longitude: -118.142959),
                 isFavorite: true),

        Location(name: "Магадан",
                 actualWeather: ActualWeather(temperature: 0, feelsTemperature: 0, iconWeather: "bkn_d", condition: ""),
                 coordinate: Coordinate(latitude: 59.5564248, longitude: 150.8181774),
                 isFavorite: true),

        Location(name: "Лос-Анджелес",
                 actualWeather: ActualWeather(temperature: 0, feelsTemperature: 0, iconWeather: "bkn_d", condition: ""),
                 coordinate: Coordinate(latitude: 34.053345, longitude: -118.242349),
                 isFavorite: true),

        Location(name: "Владивосток",
                 actualWeather: ActualWeather(temperature: 0, feelsTemperature: 0, iconWeather: "bkn_d", condition: ""),
                 coordinate: Coordinate(latitude: 43.1157617, longitude: 131.8854903),
                 isFavorite: true),

        Location(name: "Казань",
                 actualWeather: ActualWeather(temperature: 0, feelsTemperature: 0, iconWeather: "bkn_d", condition: ""),
                 coordinate: Coordinate(latitude: 55.7962444, longitude: 49.1118761),
                 isFavorite: true)
    ]
}
