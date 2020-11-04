//
//  RequestService.swift
//  Weather
//
//  Created by Aleksey Bardin on 31.10.2020.
//

import Foundation

protocol RequestServiceProtocol {
    func preparationRequest(_ url: URL) -> URLRequest
}

final class RequestService: RequestServiceProtocol {

    var defaultHeaders =
        [
            "X-Yandex-API-Key": APIKey.key
        ]

    func preparationRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        return request
    }
}
