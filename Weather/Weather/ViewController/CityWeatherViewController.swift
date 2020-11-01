//
//  CityWeatherViewController.swift
//  Weather
//
//  Created by Aleksey Bardin on 31.10.2020.
//

import UIKit
import MapKit

protocol CityWeatherDelegate: class {
    func addFavouritesCity(_ city: CityInfo)
    func removeFavouritesCity(_ city: CityInfo)
}

class CityWeatherViewController: UIViewController {

    @IBOutlet private var temperature: UILabel!
    @IBOutlet private var feelsTemperature: UILabel!
    @IBOutlet private var condition: UILabel!
    @IBOutlet private var icon: UIImageView!
    private var favoriteButton: UIBarButtonItem!

    var isAddedCity: Bool = false

    var location: MKLocalSearchCompletion?
    var cityInfo: CityInfo?

    private let networkService = NetworkService()
    weak var delegate: CityWeatherDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCityWeather()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let location = location else { return }

        getLocation(location) { [weak self] location in
            guard let self = self else { return }
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)

            self.networkService.getRequest().getActualWeather(latitude, longitude) { (result) in
                switch result {
                    case .success(let weather):
                        DispatchQueue.main.async {
                            self.temperature.text = String(weather.actualWeather.temperature)
                            self.feelsTemperature.text = String(weather.actualWeather.feelsTemperature)
                            self.condition.text = String(weather.actualWeather.condition)
                        }

                    case .failure(_):
                        break
                }
            }
        }
    }

    func getLocation(_ location: MKLocalSearchCompletion, completionHandler: @escaping PlacemarkBlock) {
        let searchRequest = MKLocalSearch.Request(completion: location)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let location = response?.mapItems.first?.placemark else { return }
            completionHandler(location)
        }
    }

}

private extension CityWeatherViewController {

    func setupCityWeather() {

        guard let cityInfo = cityInfo else { return }

        isAddedCity = cityInfo.isFavorite

        let latitude = String(cityInfo.coordinate.latitude)
        let longitude = String(cityInfo.coordinate.longitude)
        networkService.getRequest().getActualWeather(latitude, longitude) { (result) in
            switch result {
                case .success(let weather):
                    DispatchQueue.main.async {
                        self.temperature.text = String(weather.actualWeather.temperature)
                        self.feelsTemperature.text = String(weather.actualWeather.feelsTemperature)
                        self.condition.text = String(weather.actualWeather.condition)
                    }

                case .failure(_):
                    break
            }
        }

//        if cityInfo.isFavorite {
            favoriteButton.image = Icon.addedFavorite
//        }
    }

    func setupNavigationBar() {
        favoriteButton = UIBarButtonItem(image: Icon.favorite,
                                         style: .plain,
                                         target: self,
                                         action: #selector(addCity))

        let backButton = UIBarButtonItem(image: Icon.back,
                                         style: .plain,
                                         target: self,
                                         action: #selector(popViewController))
        backButton.tintColor = .red
        favoriteButton.tintColor = .red

        navigationItem.rightBarButtonItems = .some([favoriteButton])
        navigationItem.leftBarButtonItem = .some(backButton)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    @objc
    func addCity() {
        guard let location = location else {
            print("Не удаеется зайти")
            guard let cityInfo = cityInfo else { return }
            delegate?.removeFavouritesCity(cityInfo)
            favoriteButton.image = Icon.favorite
            return }

        if !isAddedCity {
            favoriteButton.image = Icon.addedFavorite
        } else {
            favoriteButton.image = Icon.favorite
        }

        isAddedCity = !isAddedCity

        getLocation(location) { location in

            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)

            guard let locationName = location.title?.prefix(while: { $0 != "," }) else { return }

            self.networkService.getRequest().getActualWeather(latitude, longitude) { [weak self] (result) in
                guard let self = self else { return }

                switch result {
                    case .success(let weather):
                        guard
                            let delegate = self.delegate
                        else {
                            return
                        }

                        let city = CityInfo(
                            name: String(locationName),
                            actualWeather:
                                ActualWeather(
                                    temperature: weather.actualWeather.temperature,
                                    feelsTemperature: weather.actualWeather.feelsTemperature,
                                    iconWeather: weather.actualWeather.iconWeather,
                                    condition: weather.actualWeather.condition
                                ),
                            coordinate:
                                Coordinate(
                                    latitude: location.coordinate.latitude,
                                    longitude: location.coordinate.longitude
                                ),
                            isFavorite: true
                        )

                        if self.isAddedCity {
                            delegate.addFavouritesCity(city)
                        } else {
                            delegate.removeFavouritesCity(city)
                        }


                    case .failure(let error):
                        print(error.localizedDescription)
                        break
                }
            }
        }
    }

    @objc
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}
