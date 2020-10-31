//
//  URLService.swift
//  Weather
//
//  Created by Aleksey Bardin on 31.10.2020.
//

import Foundation

protocol URLServiceProtocol {
    func preparationURL(_ latitude: String, _ longitude: String) -> URL?
}

final class URLService: URLServiceProtocol {

    private let preparationURLComponents: URLComponentsProtocol

    init(preparationURLComponents: URLComponentsProtocol = URLComponentsService()) {
        self.preparationURLComponents = preparationURLComponents
    }

    func preparationURL(_ latitude: String, _ longitude: String) -> URL? {
        guard let url = preparationURLComponents.preparationURLComponents(latitude: latitude, longitude: longitude)?.url else { return nil }
        return url
    }
}
