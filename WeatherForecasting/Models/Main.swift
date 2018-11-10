//
//  Main.swift
//  WeatherForecasting
//
//  Created by ziad Bou Ismail on 11/3/18.
//  Copyright © 2018 Ziad. All rights reserved.
//

import Foundation

struct Main {

    var temp: Double?
    var pressure: Double?
    var humidity: Double?
    var temp_min: Double?
    var temp_max: Double?

    var temperatureCelcius: String {
        let convert: Double = 273.15
        guard let temp = temp else { return "" }
        let tempCelcius: Double = temp - convert
        return "\(Int(round(tempCelcius)))"
    }
}

extension Main {

    init?(json: [String: Any]) {
        if let temp = json["temp"] as? Double {
            self.temp = temp
        }

        if let pressure = json["pressure"] as? Double {
            self.pressure = pressure
        }

        if let humidity = json["humidity"] as? Double {
            self.humidity = humidity
        }

        if let temp_min = json["temp_min"] as? Double {
            self.temp_min = temp_min
        }

        if let temp_max = json["temp_max"] as? Double {
            self.temp_max = temp_max
        }
    }
}
