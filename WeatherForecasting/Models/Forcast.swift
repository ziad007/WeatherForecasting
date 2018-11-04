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

    init(weatherDictionaries: NSDictionary) {

        guard let forecastsContainer = weatherDictionaries["list"] as? [NSDictionary] else { return }

        self.values = forecastsContainer.compactMap {forcastDictionary in
            guard let weatherData = WeatherData(json: forcastDictionary) else { return nil }
            return weatherData
        }
    }
}
