//
//  Icons.swift
//  Weather
//
//  Created by Aleksey Bardin on 01.11.2020.
//

import UIKit

enum Configuration {
    static let black = UIImage.SymbolConfiguration(weight: .black)
    static let bold = UIImage.SymbolConfiguration(weight: .bold)
    static let heavy = UIImage.SymbolConfiguration(weight: .heavy)
    static let light = UIImage.SymbolConfiguration(weight: .light)
    static let medium = UIImage.SymbolConfiguration(weight: .medium)
    static let regular = UIImage.SymbolConfiguration(weight: .regular)
    static let semibold = UIImage.SymbolConfiguration(weight: .semibold)
    static let thin = UIImage.SymbolConfiguration(weight: .thin)
}

enum Icon {
    static let favorite = UIImage(systemName: "star", withConfiguration: Configuration.medium)
    static let addedFavorite = UIImage(systemName: "star.fill", withConfiguration: Configuration.medium)
    static let back = UIImage(systemName: "chevron.left", withConfiguration: Configuration.medium)
}
