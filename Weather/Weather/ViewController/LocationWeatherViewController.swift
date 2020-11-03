//
//  LocationWeatherViewController.swift
//  Weather
//
//  Created by Aleksey Bardin on 31.10.2020.
//

import UIKit
import MapKit

protocol LocationWeatherDelegate: class {
    func addFavouritesLocation(_ city: Location)
    func removeFavouritesLocation(_ city: Location)
}

class LocationWeatherViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private var temperature: UILabel!
    @IBOutlet private var feelsTemperature: UILabel!
    @IBOutlet private var condition: UILabel!
    @IBOutlet private var icon: UIImageView!

    // MARK: - Private Properties

    private var favoriteButton: UIBarButtonItem!
    private let networkService = NetworkService()
    private let locationService = LocationService()
    private let urlIcon = URLIconWeather()
    private var isAddedCity: Bool = false

    // MARK: - Public Properties

    public var location: MKLocalSearchCompletion?
    public var locationInfo: Location?
    public weak var delegate: LocationWeatherDelegate?

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

                let loadDataGroup = DispatchGroup()

                switch result {
                    case .success(let weather):

                        DispatchQueue.global(qos: .userInitiated).async {
                            loadDataGroup.enter()

                            let locationTemperature = String(weather.actualWeather.temperature) + Text.degrees
                            let locationFeelsTemperature = Text.feels + String(weather.actualWeather.feelsTemperature) + Text.degrees
                            let locationCondition = Conditions.init(String(weather.actualWeather.condition))?.description
                            let icon = weather.actualWeather.iconWeather

                            loadDataGroup.leave()

                            guard let url = self.urlIcon.preparationURL(icon) else {
                                return
                            }

                            loadDataGroup.notify(queue: .main) {
                                self.temperature.text = locationTemperature
                                self.feelsTemperature.text = locationFeelsTemperature
                                self.condition.text = locationCondition
                                self.icon.kf.setImage(with: url)
                            }
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

private extension LocationWeatherViewController {

    func setupCityWeather() {

        guard let cityInfo = locationInfo else { return }

        isAddedCity = cityInfo.isFavorite
        setupFavoriteButton()

        let latitude = String(cityInfo.coordinate.latitude)
        let longitude = String(cityInfo.coordinate.longitude)
        networkService.getRequest().getActualWeather(latitude, longitude) { [weak self] result in

            guard let self = self else { return }

            let loadDataGroup = DispatchGroup()

            switch result {
                case .success(let weather):
                    DispatchQueue.global(qos: .userInitiated).async {
                        loadDataGroup.enter()

                        let locationTemperature = String(weather.actualWeather.temperature) + Text.degrees
                        let locationFeelsTemperature = Text.feels + String(weather.actualWeather.feelsTemperature) + Text.degrees
                        let locationCondition = Conditions.init(String(weather.actualWeather.condition))?.description
                        let icon = weather.actualWeather.iconWeather

                        loadDataGroup.leave()

                        guard let url = self.urlIcon.preparationURL(icon) else {
                            return
                        }

                        print(url)

                        loadDataGroup.notify(queue: .main) {
                            self.temperature.text = locationTemperature
                            self.feelsTemperature.text = locationFeelsTemperature
                            self.condition.text = locationCondition
                            self.icon.kf.setImage(with: url)
                        }
                    }

                case .failure(let error):
                    print(error.localizedDescription)
                    break
            }
        }
    }

    @objc
    func addLocation() {
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
                                         action: #selector(addLocation))

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
