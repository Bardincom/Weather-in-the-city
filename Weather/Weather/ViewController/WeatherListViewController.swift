//
//  SearchViewController.swift
//  Weather
//
//  Created by Aleksey Bardin on 30.10.2020.
//

import UIKit
import MapKit

class WeatherListViewController: UIViewController {

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

        searchCompleter.delegate = self
        searchCompleter.pointOfInterestFilter = .excludingAll

        searchController.searchBar.delegate = self
        
        //        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }
}

extension WeatherListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            print("searchResults: \(searchResults.count)")
            return searchResults.count
        }

        print("selectedResults: \(selectedResults.count)")
        return selectedResults.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(reusable: WeatherListTableViewCell.self, for: indexPath)
        let result: MKLocalSearchCompletion
        if searchController.isActive {
            result = searchResults[indexPath.row]
            cell.city.text = result.title
        } else {
            result = selectedResults[indexPath.row]
            cell.city.text = String(result.title.prefix(while: { $0 != "," }))
        }

        return cell
    }
}

extension WeatherListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if searchController.isActive {
            print(searchController.isActive)
            let completion = searchResults[indexPath.row]
            selectedResults.append(completion)
            searchController.isActive = !searchController.isActive
            print(searchController.isActive)
            tableView.reloadData()
            return
        }

        let completion = selectedResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let info = response?.mapItems.first?.placemark

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

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }

}

