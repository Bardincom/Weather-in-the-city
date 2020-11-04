//
//  NetworkService.swift
//  Weather
//
//  Created by Aleksey Bardin on 31.10.2020.
//

import Foundation

final class NetworkService {

    private let getService: GETProtocol

    init(getService: GETProtocol = GETService()) {
        self.getService = getService
    }

    func getRequest() -> GETProtocol {
        return getService
    }
}
