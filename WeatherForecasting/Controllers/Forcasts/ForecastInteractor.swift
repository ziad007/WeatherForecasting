import Foundation
import CoreLocation

protocol ForecastInteractorInputs {
     func fetchForecasting()
}

protocol ForecastInteractorOutputs {
    var forecastResponse: Forecast? { get }
    var forecastingWeatherByDay: Dictionary<Int, [WeatherData]> { get }
}

final class ForecastInteractor: ForecastInteractorInputs, ForecastInteractorOutputs {
    var forecastResponse: Forecast?
    var forecastingWeatherByDay = Dictionary<Int, [WeatherData]>()
    let numberOfDaysForecasting = 5

    var forecastService: ForecastService
    weak var controller: ForecastViewController?
    var requestloadForecastCompleteHandler: (() -> Void)?

    init() {
        forecastService = ForecastService()
    }

    func fetchForecasting() {
        guard let lastLocation = LocationStore.shared.getLastLocation() else { return }

        forecastService.getForecast(for: lastLocation) { [weak self] (response) in
            guard let localSelf = self else { return }
            switch response {
            case .success(let response):
                localSelf.forecastResponse = response
                localSelf.fillForecastWeaterDataByDay()
                localSelf.requestloadForecastCompleteHandler?()
            case .failure(let error):
                localSelf.controller?.showErrorAlert(message: error.domain)
            }
        }
    }

    private func getForcastingWeather(for dayIndex: Int) -> [WeatherData] {
        guard let forecastResponse = forecastResponse else { return [] }
        return forecastResponse.values.filter { weatherData in
            let calendar = NSCalendar.current

            let components = calendar.dateComponents([.day], from:  Date(), to:  weatherData.dt)
            return components.day == dayIndex
        }

    }
    private func fillForecastWeaterDataByDay() {
        for index in 0...numberOfDaysForecasting {
            forecastingWeatherByDay[index] = getForcastingWeather(for: index)
        }
    }
}
