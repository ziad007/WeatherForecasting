//
//  PhotoInteractor.swift
//  Photos
//
//  Created by ziad Bou Ismail on 9/30/18.
//  Copyright © 2018 ziad Bou Ismail. All rights reserved.
//

import Foundation

protocol ForecastInteractorInputs {
    func fetchForecast(for lat: Double, long: Double)
    func getForcastWeathers(for dayIndex: Int) -> [WeatherData]
}

protocol ForecastInteractorOutputs {
    var forecastResponse: Forecast? { get }
    var forecastDictionary: Dictionary<Int, [WeatherData]> { get }
}

final class ForecastInteractor: ForecastInteractorInputs, ForecastInteractorOutputs {
    var forecastResponse: Forecast?
    var forecastDictionary = Dictionary<Int, [WeatherData]>()

    var forecastService: ForecastService
    weak var controller: ForecastViewController?
    var requestloadForecastCompleteHandler: (() -> Void)?

    init() {
        forecastService = ForecastService()
    }

    func fetchForecast(for lat: Double, long: Double) {
        forecastService.getForecast(for: lat, long: long) { [weak self] (response) in
            guard let localSelf = self else { return }
            switch response {
            case .success(let response):
                localSelf.forecastResponse = response

                for index in 0...5 {
                    localSelf.forecastDictionary[index] = localSelf.getForcastWeathers(for: index)
                }
                localSelf.requestloadForecastCompleteHandler?()
            case .failure(let error): break
                // localSelf.controller?.showErrorAlert(message: error.domain)
            }

        }
    }

    func getForcastWeathers(for dayIndex: Int) -> [WeatherData] {

        guard let forecastResponse = forecastResponse else { return [] }
        return forecastResponse.values.filter { weatherData in
            let calendar = NSCalendar.current

            let components = calendar.dateComponents([.day], from:  Date() , to:  weatherData.dt ?? Date())
            print(components.day)
            return components.day == dayIndex
        }

    }
}
