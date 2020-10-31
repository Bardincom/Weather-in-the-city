//
//  URLComponentsService.swift
//  Weather
//
//  Created by Aleksey Bardin on 31.10.2020.
//

import Foundation

protocol URLComponentsProtocol {
    func preparationURLComponents(latitude: String, longitude: String) -> URLComponents?
}

final class URLComponentsService: URLComponentsProtocol {

    func preparationURLComponents(latitude: String, longitude: String) -> URLComponents? {
        var urlComponents = URLComponents()
        urlComponents.scheme = URLComponent.scheme
        urlComponents.host = URLComponent.host
        urlComponents.path = URLComponent.path
        urlComponents.queryItems = [
            URLQueryItem(name: QueryItems.latitude, value: "\(latitude)"),
          URLQueryItem(name: QueryItems.longitude, value: "\(longitude)"),
        ]
        
        return urlComponents
    }
}
