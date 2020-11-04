//
//  Coordinate.swift
//  Weather
//
//  Created by Aleksey Bardin on 01.11.2020.
//

import Foundation

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

