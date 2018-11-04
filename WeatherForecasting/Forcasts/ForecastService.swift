
import Foundation

typealias ForecastResponse = (Result<Forecast?, NSError>) -> Void

protocol ForecastServiceProtocol {
    func getForecast(for lat: Double, long: Double, completionHandler: @escaping ForecastResponse)
}

final class ForecastService: ForecastServiceProtocol {
    let apiCall: APICall

    init(apiCall: APICall = APICall()) {
        self.apiCall = apiCall
    }

     func getForecast(for lat: Double, long: Double, completionHandler: @escaping ForecastResponse) {

        if let forecastContainer =  WeatherDatatore.shared.getCurrentWeatherData(for: .forecast) {
            let weather = Forecast(weatherDictionaries: forecastContainer)
            completionHandler(Result.success(weather))
        }

        let api = ForecastApi.GetForecast(lat: lat, long: long)
        self.apiCall.sendRequest(api) { response in
            switch(response) {
            case .success(let result):

                guard let forecastContainer = result as? NSDictionary else { return }
                WeatherDatatore.shared.saveWeatherData(with: forecastContainer, for: .forecast)

                let weather = Forecast(weatherDictionaries: forecastContainer)
                completionHandler(Result.success(weather))
            case .failure(let error):
                completionHandler(Result.failure(error as NSError))
            }
        }
    }
}
