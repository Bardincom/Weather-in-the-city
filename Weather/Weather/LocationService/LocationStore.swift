//
//  LocationStore.swift
//  Weather
//
//  Created by Aleksey Bardin on 03.11.2020.
//

import Foundation

public final class LocationStore {

    public static let shared: LocationStore = .init()

    /// Список локаций, добавленных пользователем. Добавленные добавленные сохраняются в UserDefaults и доступны после перезагрузки приложения.
    public var locations: [Location] = [] {
        didSet {
            save()
        }
    }

    private lazy var userDefaults: UserDefaults = .standard

    private lazy var decoder: JSONDecoder = .init()

    private lazy var encoder: JSONEncoder = .init()

    // MARK: - Lifecycle
    public func addLocation(_ location: Location) {
        save()
    }

    // MARK: - Private

    private init() {
        guard let data = userDefaults.data(forKey: "locations") else {
            return
        }

        do {
            locations = try decoder.decode([Location].self, from: data)
            print(locations)
        }
        catch {
            print("Ошибка декодирования сохранённых локаций", error)
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
}

