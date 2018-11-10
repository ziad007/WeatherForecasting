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
        guard checkLocationIfEnabled() == true else {
             controller?.showErrorAlertToEnableLocation(message: "Please enable location services in the settings")
            return
        }
        guard let locDictionary = DataStore.shared.getData(for: .location) else {
            return
        }

        let location = Location(dict: locDictionary)
        if !isFetchingData {
            isFetchingData = true
            currentWeatherService.getCurrentWeather(for: location) { [weak self] (response) in
                guard let localSelf = self else { return }
                localSelf.isFetchingData = false

                switch response {
                case .success(let response):
                    localSelf.weatherResponse = response
                    localSelf.requestloadCurrentWeatherCompleteHandler?()
                case .failure(let error):
                    localSelf.controller?.showErrorAlert(message: error.domain)

                }
            }
        }
    }

    private func checkLocationIfEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .denied:
                return false
            default:
                return true
            }
        } else {
            return false
        }

    }
}
