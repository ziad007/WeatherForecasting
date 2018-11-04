import Foundation
import CoreLocation

protocol CurrentWeatherInteractorInputs {
   func fetchCurrentWeather()
}

protocol CurrentWeatherInteractorOutputs {
    var weatherResponse: WeatherData? { get }
}

final class CurrentWeathInteractor: CurrentWeatherInteractorInputs, CurrentWeatherInteractorOutputs {
    var weatherResponse: WeatherData?
    var currentWeatherService: CurrentWeatherService
    weak var controller: CurrentWeatherViewController?
    var requestloadCurrentWeatherCompleteHandler: (() -> Void)?
    private var isFetchingData = false

    init() {
        currentWeatherService = CurrentWeatherService()
    }

    func fetchCurrentWeather() {
        guard let lastLocation = LocationStore.shared.getLastLocation() else { return }
        if !isFetchingData {
            isFetchingData = true
            currentWeatherService.getCurrentWeather(for: lastLocation) { [weak self] (response) in
                guard let localSelf = self else { return }
                localSelf.isFetchingData = false

                switch response {
                case .success(let response):
                    localSelf.weatherResponse = response
                    localSelf.requestloadCurrentWeatherCompleteHandler?()
                case .failure(let error): break
                }
            }
        }
    }
}
