//
//  SearchViewController.swift
//  Weather
//
//  Created by Aleksey Bardin on 30.10.2020.
//

import UIKit
import MapKit

final class WeatherListViewController: UIViewController {

    @IBOutlet var weatherListTableView: UITableView! {
        willSet {
            newValue.register(nibCell: WeatherListTableViewCell.self)
            newValue.tableFooterView = UIView()
        }
    }

    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
//    var selectedResults = [MKLocalSearchCompletion]()
    var citiesInformation = [CityInfo]()

    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        searchCompleterConfiguration()
        searchControllerConfiguration()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weatherListTableView.reloadData()
    }

    func searchControllerConfiguration() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Title.weatherViewControllerTitle
        navigationItem.searchController = searchController
    }

    func searchCompleterConfiguration() {
        searchCompleter.delegate = self
        searchCompleter.pointOfInterestFilter = .excludingAll
    }
}

extension WeatherListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        }

        return citiesInformation.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(reusable: WeatherListTableViewCell.self, for: indexPath)
//        let result: MKLocalSearchCompletion

        if searchController.isActive {
            let result = searchResults[indexPath.row]
            cell.displayResultSearchCities(result)
        } else {
            let city = citiesInformation[indexPath.row]
//            print(city)
            cell.displayFavoriteCity(city)
        }

        return cell
    }
}

extension WeatherListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cityWeatherViewController = CityWeatherViewController()

        if searchController.isActive {
            let completion = searchResults[indexPath.row]
            cityWeatherViewController.location = completion
            cityWeatherViewController.delegate = self
            navigationController?.pushViewController(cityWeatherViewController, animated: true)
            searchController.isActive = !searchController.isActive
            tableView.reloadData()
            return
        }

        let selectCity = citiesInformation[indexPath.row]
        cityWeatherViewController.cityInfo = selectCity
        cityWeatherViewController.delegate = self
        navigationController?.pushViewController(cityWeatherViewController, animated: true)


    }
}

extension WeatherListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

extension WeatherListViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results.filter { result in
            guard result.title.contains(",") else { return false }
            return true
        }

        searchResults = results
        weatherListTableView.reloadData()
    }
}

extension WeatherListViewController: CityWeatherDelegate {
    func removeFavouritesCity(_ city: CityInfo) {
        print("1", citiesInformation.count)
        guard let index = citiesInformation.firstIndex(where: { (removeCity) -> Bool in
            removeCity.name == city.name
        }) else { return }

        citiesInformation.remove(at: index)
        print("2", citiesInformation.count)


    }

    func addFavouritesCity(_ city: CityInfo) {
        citiesInformation.append(city)
//        print(citiesInformation.count)
    }
}

