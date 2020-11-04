//
//  DataTaskService.swift
//  Weather
//
//  Created by Aleksey Bardin on 31.10.2020.
//

import Foundation

protocol DataTaskServiceProtocol {
    func dataTask<T: Codable>(with request: URLRequest, completionHandler: @escaping ResultBlock<T>)
}

class DataTaskService: DataTaskServiceProtocol {

    private let sharedSession = URLSession.shared
    private let decoder = JSONDecoder()

    /// Получение данных после запроса
    func dataTask<T: Codable>(with request: URLRequest,
                     completionHandler: @escaping ResultBlock<T>) {
        let dataTask = sharedSession.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if let error = error {
                print("Возникла ошибка: \(error.localizedDescription)")
            }

            guard let data = data else { return }

            do {
                let result = try self.decoder.decode(T.self, from: data)
                completionHandler(.success(result))
            } catch let error {
              print(error)
            }
        }

        dataTask.resume()
    }

}

