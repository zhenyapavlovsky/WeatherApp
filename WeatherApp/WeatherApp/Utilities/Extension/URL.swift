//
//  URL.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 31.10.2023.
//

import Foundation

extension URL {
    
    var urlFixed: URL? {
        let urlString = self.absoluteString
        if urlString.starts(with: "//") {
            return URL(string: "https:" + urlString)
        }
        return self
    }
}
