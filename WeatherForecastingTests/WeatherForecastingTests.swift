//
//  WeatherForecastingTests.swift
//  WeatherForecastingTests
//
//  Created by ziad Bou Ismail on 11/2/18.
//  Copyright © 2018 Ziad. All rights reserved.
//

import XCTest
@testable import WeatherForecasting

class WeatherForecastingTests: XCTestCase {

    var forecastResponse: Forecast?

    class MockService: ForecastServiceProtocol {

        func getForecast(for location: Location, completionHandler: @escaping ForecastResponse) {

            let jsonString = "{\"city\":{\"id\":1851632,\"name\":\"Shuzenji\"},\"coord\":{\"lon\":138.933334,\"lat\":34.966671},\"country\":\"JP\",\"cod\":\"200\",\"message\":0.0045,\"cnt\":38,\"list\":[{\"dt\":1406106000,\"main\":{\"temp\":298.77,\"temp_min\":298.77,\"temp_max\":298.774,\"pressure\":1005.93,\"sea_level\":1018.18,\"grnd_level\":1005.93,\"humidity\":87,\"temp_kf\":0.26},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcastclouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":88},\"wind\":{\"speed\":5.71,\"deg\":229.501},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-07-2309:00:00\"}]}"

            let data = jsonString.data(using: .utf8)!
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            let forecast = Forecast(forecatDictionary: json as! NSDictionary)
            completionHandler(Result.success(forecast))
        }
    }

    var interactor: ForecastInteractor!

    override func setUp() {

        interactor = ForecastInteractor()
        interactor.forecastService = MockService()
        super.setUp()
    }

    func testViewDidLoad() {

        let location = Location(long: 34, lat: 34)
        DataStore.shared.save(data: location.dictionary as NSDictionary, for: .location)

        interactor.fetchForecasting()
        XCTAssertEqual(interactor.forecastingWeatherByDay.count, 6)
        XCTAssertEqual(interactor.cityName, "Shuzenji")
    }
}
