//
//  GETService.swift
//  Weather
//
//  Created by Aleksey Bardin on 31.10.2020.
//

import Foundation

protocol GETProtocol {
    func getActualWeather(_ latitude: String,
                          _ longitude: String,
                          completionHandler: @escaping ResultBlock<WeatherModel>)
}


class GETService: GETProtocol {

    private let urlService: URLServiceProtocol
    private let requestService: RequestServiceProtocol
    private let dataProvider: DataTaskServiceProtocol

    init(urlService: URLServiceProtocol = URLService(),
         requestService: RequestServiceProtocol = RequestService(),
         dataProvider: DataTaskServiceProtocol = DataTaskService()) {
        self.urlService = urlService
        self.requestService = requestService
        self.dataProvider = dataProvider
    }


    func getActualWeather(_ latitude: String,
                          _ longitude: String,
                          completionHandler: @escaping ResultBlock<WeatherModel>) {
        guard let url = urlService.preparationURL(latitude, longitude) else { return }
        let request = requestService.preparationRequest(url)
        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }
}

