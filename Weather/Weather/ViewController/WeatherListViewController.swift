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
    var selectedResults = [MKLocalSearchCompletion]()

    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        searchCompleterConfiguration()
        searchControllerConfiguration()
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

        return selectedResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(reusable: WeatherListTableViewCell.self, for: indexPath)
        let result: MKLocalSearchCompletion

        if searchController.isActive {
            result = searchResults[indexPath.row]
            cell.displayResult(result)
        } else {
            result = selectedResults[indexPath.row]
            print(result)
            cell.displayResult(result)
        }

        return cell
    }
}

extension WeatherListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if searchController.isActive {
            let completion = searchResults[indexPath.row]
            selectedResults.append(completion)
            searchController.isActive = !searchController.isActive
            tableView.reloadData()
            return
        }

        let completion = selectedResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let info = response?.mapItems.first?.placemark
            print(String(describing: info?.coordinate.latitude))
            print(String(describing: info?.coordinate.longitude))
            print(String(describing: info?.title))
        }
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

