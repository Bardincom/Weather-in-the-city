//
//  MKLocalSearchCompleter.swift
//  Weather
//
//  Created by Aleksey Bardin on 02.11.2020.
//

import MapKit

extension MKLocalSearchCompleter {
    func selectionResult() -> [MKLocalSearchCompletion] {
        return self.results.filter { result in
            guard result.title.contains(",") else { return false }
            return true
        }
    }
}
