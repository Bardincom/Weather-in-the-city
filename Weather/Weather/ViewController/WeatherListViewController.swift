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
    private var locationStore = LocationStore.shared
    private var refreshControl: UIRefreshControl?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        searchCompleterConfiguration()
        searchControllerConfiguration()
        configureRefreshControl()
        addObserver()
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

        return locationStore.getCountLocations()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(reusable: WeatherListTableViewCell.self, for: indexPath)

        if searchController.isActive {
            let result = searchResults[indexPath.row]
            cell.displayResultSearchLocation(result)
        } else {
            let location = locationStore.locations[indexPath.row]
            cell.displayFavoriteLocation(location)
        }

        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {

        let location = locationStore.locations[indexPath.row]

      if editingStyle == .delete {
        guard let index = locationStore.locations.firstIndex(where: { (removeLocation) -> Bool in
            removeLocation == location
        }) else { return }
        locationStore.locations.remove(at: index)
        tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
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

        let selectLocation = locationStore.locations[indexPath.row]
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

// MARK: - Configuration WeatherListViewController

private extension WeatherListViewController {
    func searchControllerConfiguration() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Text.searchBarPlaceholder
        navigationItem.searchController = searchController
    }

    func searchCompleterConfiguration() {
        searchCompleter.delegate = self
        searchCompleter.pointOfInterestFilter = .excludingAll
    }

    func configureRefreshControl () {

        weatherListTableView.refreshControl = UIRefreshControl()
        weatherListTableView.refreshControl?.addTarget(
            self,
            action: #selector(refresh),
            for: .valueChanged)
    }

    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidUpdateWeather), name: .didUpdateWeather, object: nil)
    }

    @objc
    func handleDidUpdateWeather() {
        weatherListTableView.reloadData()
    }

    @objc
    func refresh() {

        locationStore.reloadLocations()

        DispatchQueue.main.async {
            self.weatherListTableView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - LocationWeatherDelegate

extension WeatherListViewController: LocationWeatherDelegate {
    func removeFavouritesLocation(_ location: Location) {
        guard let index = locationStore.locations.firstIndex(where: { (removeLocation) -> Bool in
            removeLocation == location
        }) else { return }

        locationStore.locations.remove(at: index)
    }

    func addFavouritesLocation(_ location: Location) {
        guard !locationStore.locations.contains(location) else {
            Alert.showAlert(self, Text.alertMessage) {
                self.removeFavouritesLocation(location)
            }
            return
        }
        locationStore.locations.append(location)
    }
}
