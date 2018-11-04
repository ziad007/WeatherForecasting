
import Foundation

typealias WeatherResponse = (Result<WeatherData?, NSError>) -> Void

protocol CurrentWeatherServiceProtocol {
    func getCurrentWeather(for long: Double, lat: Double, completionHandler: @escaping WeatherResponse)
}

final class CurrentWeatherService: CurrentWeatherServiceProtocol {

    let apiCall: APICall

    init(apiCall: APICall = APICall()) {
        self.apiCall = apiCall
    }

    func getCurrentWeather(for long: Double, lat: Double, completionHandler: @escaping WeatherResponse) {

        if let weatherContainer =  WeatherDatatore.shared.getCurrentWeatherData(for: .currentWeather) {
            let weather = WeatherData(json: weatherContainer)
            completionHandler(Result.success(weather))
        }

        let api = WeatherApi.GetCurrentWeather(lat: lat, long: long)
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
