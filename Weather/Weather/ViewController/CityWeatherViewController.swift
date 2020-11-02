//
//  CityWeatherViewController.swift
//  Weather
//
//  Created by Aleksey Bardin on 31.10.2020.
//

import UIKit
import MapKit

protocol CityWeatherDelegate: class {
    func addFavouritesLocation(_ city: Location)
    func removeFavouritesLocation(_ city: Location)
}

class CityWeatherViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private var temperature: UILabel!
    @IBOutlet private var feelsTemperature: UILabel!
    @IBOutlet private var condition: UILabel!
    @IBOutlet private var icon: UIImageView!

    // MARK: - Private Properties

    private var favoriteButton: UIBarButtonItem!
    private let networkService = NetworkService()
    private let locationService = LocationService()
    private var isAddedCity: Bool = false

    // MARK: - Public Properties

    public var location: MKLocalSearchCompletion?
    public var locationInfo: Location?
    public weak var delegate: CityWeatherDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCityWeather()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let location = location else {
            title = locationInfo?.name
            return
        }

        title = location.setShortNamePlace()

        location.getLocation { location in

            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)

            self.networkService.getRequest().getActualWeather(latitude, longitude) { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(let weather):
                        DispatchQueue.main.async {
                            self.temperature.text = String(weather.actualWeather.temperature)
                            self.feelsTemperature.text = String(weather.actualWeather.feelsTemperature)
                            self.condition.text = String(weather.actualWeather.condition)
                        }

                    case .failure(let error):
                        print(error.localizedDescription)
                        break
                }
            }
        }
    }
}

// MARK: - Private Methods

private extension CityWeatherViewController {

    func setupCityWeather() {

        guard let cityInfo = locationInfo else { return }

        isAddedCity = cityInfo.isFavorite
        setupFavoriteButton()

        let latitude = String(cityInfo.coordinate.latitude)
        let longitude = String(cityInfo.coordinate.longitude)
        networkService.getRequest().getActualWeather(latitude, longitude) { [weak self] result in

            guard let self = self else { return }

            switch result {
                case .success(let weather):
                    DispatchQueue.main.async {
                        self.temperature.text = String(weather.actualWeather.temperature)
                        self.feelsTemperature.text = String(weather.actualWeather.feelsTemperature)
                        self.condition.text = String(weather.actualWeather.condition)
                    }

                case .failure(let error):
                    print(error.localizedDescription)
                    break
            }
        }
    }

    @objc
    func addCity() {
        guard let location = location else {
            removeLocation()
            return
        }

        isAddedCity = !isAddedCity

        setupFavoriteButton()

        let locationName = location.setShortNamePlace()

        location.getLocation { (location) in
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)

            self.networkService.getRequest().getActualWeather(latitude, longitude) { [weak self] (result) in
                guard
                    let self = self,
                    let delegate = self.delegate
                else {
                    return
                }

                switch result {
                    case .success(let weather):

                        let location = self.locationService.createLocation(locationName,
                                                           weather,
                                                           location)

                        if self.isAddedCity {
                            delegate.addFavouritesLocation(location)
                        } else {
                            delegate.removeFavouritesLocation(location)
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

    func setupFavoriteButton() {
        if isAddedCity {
            favoriteButton.image = Icon.addedFavorite
        } else {
            favoriteButton.image = Icon.favorite
        }
    }

    func removeLocation() {
        guard
            let locationInfo = locationInfo,
            let delegate = delegate
        else {
            return
        }

        delegate.removeFavouritesLocation(locationInfo)
        favoriteButton.image = Icon.favorite
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

        backButton.tintColor = Colors.buttonColor
        favoriteButton.tintColor = Colors.buttonColor

        navigationItem.rightBarButtonItems = .some([favoriteButton])
        navigationItem.leftBarButtonItem = .some(backButton)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
