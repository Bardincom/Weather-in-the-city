//
//  MKLocalSearchCompletion+Extension.swift
//  Weather
//
//  Created by Aleksey Bardin on 02.11.2020.
//

import MapKit

extension MKLocalSearchCompletion {
    typealias PlacemarkBlock = (MKPlacemark) -> Void
    
   func setShortNamePlace() -> String {
        String(self.title.prefix(while: { $0 != "," }))
    }

    func getLocation(completionHandler: @escaping PlacemarkBlock) {
        let searchRequest = MKLocalSearch.Request(completion: self)

        let search = MKLocalSearch(request: searchRequest)
        
        search.start { (response, error) in
            guard let location = response?.mapItems.first?.placemark else { return }
            completionHandler(location)
        }
    }
}
