//
//  Forcast.swift
//  WeatherForecasting
//
//  Created by ziad Bou Ismail on 11/3/18.
//  Copyright © 2018 Ziad. All rights reserved.
//

import Foundation

struct Forecast {

    var values = [WeatherData]()
    var city: City?

    init(forecatDictionary: NSDictionary) {

        guard let forecastsContainer = forecatDictionary["list"] as? [NSDictionary] else { return }

        if let cityContainer = forecatDictionary["city"] as? [String: Any] {
            self.city = City(json: cityContainer)
        }

        self.values = forecastsContainer.compactMap {forcastDictionary in
            guard let weatherData = WeatherData(json: forcastDictionary) else { return nil }
            return weatherData
        }
    }
}
