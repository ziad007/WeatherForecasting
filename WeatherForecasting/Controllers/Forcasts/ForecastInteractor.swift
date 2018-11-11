import Foundation

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

    var forecastService: ForecastServiceProtocol
    weak var controller: ForecastViewController?
    var requestloadForecastCompleteHandler: (() -> Void)?

    init() {
        forecastService = ForecastService()
    }

    var cityName: String {
        return forecastResponse?.city?.name ?? ""
    }

    func fetchForecasting() {
        guard let locDictionary = DataStore.shared.getData(for: .location) else {
              controller?.showErrorAlert(message: "Your location is not set yet, please try again")
            return
        }

        let location = Location(dict: locDictionary)

        forecastService.getForecast(for: location) { [weak self] (response) in
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

            let components = calendar.dateComponents([.day], from: Date(), to:  weatherData.dt)
            return components.day == dayIndex
        }

    }
    private func fillForecastWeaterDataByDay() {
        for dayIndex in 0...numberOfDaysForecasting {
            forecastingWeatherByDay[dayIndex] = getForcastingWeather(for: dayIndex)
        }
    }
}
