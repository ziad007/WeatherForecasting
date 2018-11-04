
import Foundation
import CoreLocation

typealias WeatherResponse = (Result<WeatherData?, NSError>) -> Void

protocol CurrentWeatherServiceProtocol {
    func getCurrentWeather(for loc: CLLocation, completionHandler: @escaping WeatherResponse)
}

final class CurrentWeatherService: CurrentWeatherServiceProtocol {

    let apiCall: APICall

    init(apiCall: APICall = APICall()) {
        self.apiCall = apiCall
    }

    func getCurrentWeather(for loc: CLLocation,
                           completionHandler: @escaping WeatherResponse) {

        if let weatherContainer =  WeatherDatatore.shared.getWeatherData(
            for: .currentWeather) {
            let weather = WeatherData(json: weatherContainer)
            completionHandler(Result.success(weather))
        }

        let api = WeatherApi.GetCurrentWeather(lat: loc.coordinate.latitude, long: loc.coordinate.longitude)
        self.apiCall.sendRequest(api) { response in
            switch(response) {
            case .success(let result):
                guard let weatherContainer = result as? NSDictionary else { return }
                WeatherDatatore.shared.saveWeatherData(with: weatherContainer, for: .currentWeather)

               let weather = WeatherData(json: weatherContainer)
                completionHandler(Result.success(weather))

            case .failure(let error):
                completionHandler(Result.failure(error as NSError))
            }
        }
    }
}
