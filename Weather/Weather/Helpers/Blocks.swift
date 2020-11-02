//
//  Blocks.swift
//  Weather
//
//  Created by Aleksey Bardin on 31.10.2020.
//

import Foundation
import MapKit

typealias ResultBlock<T> = (Result<T, Error>) -> Void
