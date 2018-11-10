
import Foundation

typealias WeatherResponse = (Result<WeatherData?, NSError>) -> Void

protocol CurrentWeatherServiceProtocol {
    func getCurrentWeather(for loc: Location, completionHandler: @escaping WeatherResponse)
}

final class CurrentWeatherService: CurrentWeatherServiceProtocol {

    let apiCall: APICall

    init(apiCall: APICall = APICall()) {
        self.apiCall = apiCall
    }

    func getCurrentWeather(for loc: Location,
                           completionHandler: @escaping WeatherResponse) {
        if let weatherContainer = DataStore.shared.getData(for: .weather) {
            let weather = WeatherData(json: weatherContainer)
            completionHandler(Result.success(weather))
        }

        let api = WeatherApi.GetCurrentWeather(lat: loc.lat, long: loc.long)
        self.apiCall.sendRequest(api) { response in
            switch(response) {
            case .success(let result):
                guard let weatherContainer = result as? NSDictionary else { return }

                DataStore.shared.save(data: weatherContainer, for: .weather)

               let weather = WeatherData(json: weatherContainer)
                completionHandler(Result.success(weather))

            case .failure(let error):
                completionHandler(Result.failure(error as NSError))
            }
        }
    }
}
