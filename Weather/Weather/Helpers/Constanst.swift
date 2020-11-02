//
//  Constanst.swift
//  Weather
//
//  Created by Aleksey Bardin on 30.10.2020.
//

import UIKit

enum Title {
    static let weatherViewControllerTitle = "Погода"
}

enum Text {
    static let searchBarPlaceholder = "Выберите город"
}

enum Fonts {
    static let labelFont: UIFont = .systemFont(ofSize: 17)
}

enum Colors {
    static let buttonColor: UIColor = .systemRed
}

enum Conditions: String, CustomStringConvertible {
    case clear
    case partlyCloudy
    case cloudy
    case overcast
    case drizzle
    case lightRain
    case rain
    case moderateRain
    case heavyRain
    case continuousHeavyRain
    case showers
    case wetSnow
    case lightSnow
    case snow
    case snowShowers
    case hail
    case thunderstorm
    case thunderstormWithRain
    case thunderstormWithHail

    var description: String {
        switch self {
            case .clear: return "Ясно"
            case .partlyCloudy: return "Малооблачно"
            case .cloudy: return "Облачно с прояснениями"
            case .overcast: return "Пасмурно"
            case .drizzle: return "Морось"
            case .lightRain: return "Небольшой дождь"
            case .rain: return "Дождь"
            case .moderateRain: return "Умеренно сильный дождь"
            case .heavyRain: return "Сильный дождь"
            case .continuousHeavyRain: return "Длительный сильный дождь"
            case .showers: return "Ливень"
            case .wetSnow: return "Дождь со снегом"
            case .lightSnow: return "Небольшой снег"
            case .snow: return "Снег"
            case .snowShowers: return "Снегопад"
            case .hail: return "Град"
            case .thunderstorm: return "Гроза"
            case .thunderstormWithRain: return "Дождь с грозой"
            case .thunderstormWithHail: return "Дроза с градом"
        }
    }

    init?(_ condition: String) {
        switch condition {
            case "clear": self = .clear
            case "partly-cloudy": self = .partlyCloudy
            case "cloudy": self = .cloudy
            case "overcast": self = .overcast
            case "drizzle": self = .drizzle
            case "light-rain": self = .lightRain
            case "rain": self = .rain
            case "moderate-rain": self = .moderateRain
            case "heavy-rain": self = .heavyRain
            case "continuous-heavy-rain": self = .continuousHeavyRain
            case "showers": self = .showers
            case "wet-snow": self = .wetSnow
            case "light-snow": self = .lightSnow
            case "snow": self = .snow
            case "snow-showers": self = .snowShowers
            case "hail": self = .hail
            case "thunderstorm": self = .thunderstorm
            case "thunderstorm-with-rain": self = .thunderstormWithRain
            case "thunderstorm-with-hail": self = .thunderstormWithHail
            case _ : return nil
        }
    }
}
