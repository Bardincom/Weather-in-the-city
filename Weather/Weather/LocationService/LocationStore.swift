//
//  LocationStore.swift
//  Weather
//
//  Created by Aleksey Bardin on 03.11.2020.
//

import Foundation

public final class LocationStore {

    public static let shared: LocationStore = .init()

    public var locations: [Location] = [] {
        didSet {
            self.save()
        }
    }

    private lazy var userDefaults: UserDefaults = .standard
    private lazy var decoder: JSONDecoder = .init()
    private lazy var encoder: JSONEncoder = .init()
    private var networkService = NetworkService()
    private var updateWeatherLocationGroup = DispatchGroup()

    // MARK: - Private

    private init() {

        guard let data = userDefaults.data(forKey: "locations") else {
            locations.append(contentsOf: Locations.locations)
            self.reloadLocations()
            return
        }

        do {
            locations = try decoder.decode([Location].self, from: data)

        }
        catch {
            print("Ошибка декодирования сохранённых локаций", error)
        }

        reloadLocations()
    }
}

// MARK: - Methods

extension LocationStore {

    func getCountLocations() -> Int {
        locations.count
    }

    func reloadLocations() {
        DispatchQueue.global(qos: .userInteractive).async {

            for (index, location) in self.locations.enumerated() {
                self.updateWeatherLocationGroup.enter()

                let lat = String(location.coordinate.latitude)
                let lon = String(location.coordinate.longitude)
                DispatchQueue.global(qos: .userInitiated).async {

                    self.networkService.getRequest().getActualWeather(lat, lon) { [weak self] (result) in
                        guard let self = self else { return }

                        switch result {
                            case .success(let weather):
                                self.locations[index].actualWeather.temperature = weather.actualWeather.temperature
                                self.locations[index].actualWeather.iconWeather = weather.actualWeather.iconWeather

                                self.updateWeatherLocationGroup.leave()

                            case .failure(_):
                                break
                        }
                    }
                }
            }

            self.updateWeatherLocationGroup.wait()

            DispatchQueue.main.async {
                self.updateLocationsWeather()
            }
        }
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

    private func updateLocationsWeather() {
        NotificationCenter.default.post(name: .didUpdateWeather, object: nil)
    }
}

