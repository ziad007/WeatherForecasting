//
//  PhotoInteractor.swift
//  Photos
//
//  Created by ziad Bou Ismail on 9/30/18.
//  Copyright © 2018 ziad Bou Ismail. All rights reserved.
//

import Foundation


protocol CurrentWeatherInteractorInputs {
    func fetchCurrentWeather(for long: Double, lat: Double)

}

protocol CurrentWeatherInteractorOutputs {
    var weatherResponse: WeatherData? { get }
}

final class CurrentWeathInteractor: CurrentWeatherInteractorInputs, CurrentWeatherInteractorOutputs {
    var weatherResponse: WeatherData?
    var currentWeatherService: CurrentWeatherService
    weak var controller: CurrentWeatherViewController?
    var requestloadCurrentWeatherCompleteHandler: (() -> Void)?

    init() {
        currentWeatherService = CurrentWeatherService()
    }

    func fetchCurrentWeather(for long: Double, lat: Double) {
        currentWeatherService.getCurrentWeather(for: long, lat: lat) { [weak self] (response) in
                guard let localSelf = self else { return }
                switch response {
                case .success(let response):
                    localSelf.weatherResponse = response
                    localSelf.requestloadCurrentWeatherCompleteHandler?()
                case .failure(let error): break
                  // localSelf.controller?.showErrorAlert(message: error.domain)
                }

        }
    }
}
