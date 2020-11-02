//
//  Location.swift
//  Weather
//
//  Created by Aleksey Bardin on 31.10.2020.
//

import Foundation

struct Location {
    var name: String
    var actualWeather: ActualWeather
    var coordinate: Coordinate
    var isFavorite: Bool
}

extension Location: Hashable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return
            lhs.name == rhs.name
            && lhs.coordinate.latitude == rhs.coordinate.latitude
            && lhs.coordinate.longitude == rhs.coordinate.longitude
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
        hasher.combine(self.coordinate.latitude)
        hasher.combine(self.coordinate.longitude)
    }
}
