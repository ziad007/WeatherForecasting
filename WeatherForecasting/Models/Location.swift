//
//  Location.swift
//  WeatherForecasting
//
//  Created by ziad Bou Ismail on 11/9/18.
//  Copyright © 2018 Ziad. All rights reserved.
//

import Foundation

struct Location {
    var long: Double = 0
    var lat: Double = 0

    init(long: Double, lat: Double) {
        self.long = long
        self.lat = lat
    }

    struct PropertyKey {
        static let long = "long"
        static let lat = "lat"
    }

    init(dict: NSDictionary) {
        if let lat = dict[PropertyKey.lat] as? Double {
            self.lat = lat
        }
        if let long = dict[PropertyKey.long] as? Double {
            self.long = long
        }
    }

    var dictionary: [String: Double] {
        return [PropertyKey.long: long,
                PropertyKey.lat: lat]
    }
}
