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

    // MARK: - Private Property

    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var favoriteLocations = [Location]()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        searchCompleterConfiguration()
        searchControllerConfiguration()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weatherListTableView.reloadData()
    }
}

// MARK: - TableViewDataSource

extension WeatherListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        }

        return favoriteLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(reusable: WeatherListTableViewCell.self, for: indexPath)

        if searchController.isActive {
            let result = searchResults[indexPath.row]
            cell.displayResultSearchLocation(result)
        } else {
            let city = favoriteLocations[indexPath.row]
            cell.displayFavoriteLocation(city)
        }

        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        let city = favoriteLocations[indexPath.row]

      if editingStyle == .delete {
        guard let index = favoriteLocations.firstIndex(where: { (removeCity) -> Bool in
            removeCity.name == city.name
        }) else { return }
        favoriteLocations.remove(at: index)
        tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
}

// MARK: - TableViewDelegate

extension WeatherListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cityWeatherViewController = LocationWeatherViewController()

        if searchController.isActive {
            let completion = searchResults[indexPath.row]
            cityWeatherViewController.location = completion
            cityWeatherViewController.delegate = self
            navigationController?.pushViewController(cityWeatherViewController, animated: true)
            searchController.isActive = !searchController.isActive
            tableView.reloadData()
            return
        }

        let selectLocation = favoriteLocations[indexPath.row]
        cityWeatherViewController.locationInfo = selectLocation
        cityWeatherViewController.delegate = self
        navigationController?.pushViewController(cityWeatherViewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension WeatherListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

// MARK: - LocalSearchCompleterDelegate

extension WeatherListViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {

        searchResults = completer.selectionResult()
        weatherListTableView.reloadData()
    }
}

// MARK: - LocationWeatherDelegate

extension WeatherListViewController: LocationWeatherDelegate {
    func removeFavouritesLocation(_ location: Location) {
        guard let index = favoriteLocations.firstIndex(where: { (removeLocation) -> Bool in
            removeLocation == location
        }) else { return }

        favoriteLocations.remove(at: index)
    }

    func addFavouritesLocation(_ completer: Location) {
        favoriteLocations.append(completer)
    }
}

// MARK: - Configuration WeatherListViewController

private extension WeatherListViewController {
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

