//
//  Path.swift
//  Weather
//
//  Created by Aleksey Bardin on 31.10.2020.
//

import Foundation

enum URLComponent {
    static let scheme = "https"
    static let host = "api.weather.yandex.ru"
    static let path = "/v2/forecast"
}

enum QueryItems {
    static let latitude = "lat"
    static let longitude = "lon"
}

enum APIKey {
    static let key = "26b0d075-23ef-4f97-9efd-cfab938b885c"
}

