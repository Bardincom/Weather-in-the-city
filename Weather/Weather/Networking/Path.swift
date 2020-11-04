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

// MARK: - You must enter the Yandex API key
enum APIKey {
    static let key = ""
}

