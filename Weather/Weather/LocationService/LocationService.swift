//
//  LocationService.swift
//  Weather
//
//  Created by Aleksey Bardin on 02.11.2020.
//

import Foundation
import MapKit

protocol LocationServiceProtocol {
    func createLocation(_ locationName: String,
                        _ weather: WeatherModel,
                        _ locationCoordinate: MKPlacemark ) -> Location
}

final class LocationService: LocationServiceProtocol {

    func createLocation(_ locationName: String,
                        _ weather: WeatherModel,
                        _ locationCoordinate: MKPlacemark ) -> Location {

        let actualWeather = ActualWeather(
            temperature: weather.actualWeather.temperature,
            feelsTemperature: weather.actualWeather.feelsTemperature,
            iconWeather: weather.actualWeather.iconWeather,
            condition: weather.actualWeather.condition
        )

        let coordinate = Coordinate(
            latitude: locationCoordinate.coordinate.latitude,
            longitude: locationCoordinate.coordinate.longitude
        )

        let location = Location(
            name: locationName,
            actualWeather: actualWeather,
            coordinate: coordinate,
            isFavorite: true)

        return location
    }
}
