//
//  LocationStore.swift
//  Weather
//
//  Created by Aleksey Bardin on 03.11.2020.
//

import Foundation

public final class LocationStore {

    public static let shared: LocationStore = .init()

    /// Список локаций, добавленных пользователем. Добавленные локации сохраняются в UserDefaults и доступны после перезагрузки приложения.
    public var locations: [Location] = [] {
        didSet {
            save()
        }
    }

    private lazy var userDefaults: UserDefaults = .standard
    private lazy var decoder: JSONDecoder = .init()
    private lazy var encoder: JSONEncoder = .init()
    private var networkService = NetworkService()
    private var reloadGroup = DispatchGroup()

    // MARK: - Lifecycle
    private func reloadLocations(_ locations: [Location]) {
        for (index, location) in locations.enumerated() {
            print(location.name, location.actualWeather.temperature, location.coordinate.latitude)

            let lat = String(location.coordinate.latitude)
            let lon = String(location.coordinate.longitude)
            networkService.getRequest().getActualWeather(lat, lon) { (result) in
                switch result {
                    case .success(let weather):
                        DispatchQueue.main.async {
                            self.locations[index].actualWeather.temperature = weather.actualWeather.temperature
                            print(weather.coordinate, weather.actualWeather.temperature)
                            self.locations[index].actualWeather.iconWeather = weather.actualWeather.iconWeather
                        }
                    case .failure(_):
                        break
                }
            }
        }

    }

    // MARK: - Private

    private init() {
        guard let data = userDefaults.data(forKey: "locations") else {
            return
        }

        do {
            locations = try decoder.decode([Location].self, from: data)

        }
        catch {
            print("Ошибка декодирования сохранённых локаций", error)
        }

        reloadLocations(locations)
    }

    private func save() {
        do {

            let data = try encoder.encode(locations)

            userDefaults.setValue(data, forKey: "locations")

        }
        catch {
            print("Ошибка кодирования локации для сохранения", error)
        }
    }
}

