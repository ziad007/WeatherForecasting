
import Foundation
import CoreLocation

typealias ForecastResponse = (Result<Forecast?, NSError>) -> Void

protocol ForecastServiceProtocol {
    func getForecast(for location: CLLocation,
                     completionHandler: @escaping ForecastResponse)
}

final class ForecastService: ForecastServiceProtocol {
    let apiCall: APICall

    init(apiCall: APICall = APICall()) {
        self.apiCall = apiCall
    }

     func getForecast(for location: CLLocation,
                      completionHandler: @escaping ForecastResponse) {

        if let forecastContainer = WeatherDatatore.shared.getWeatherData(for: .forecast) {
            let weather = Forecast(weatherDictionaries: forecastContainer)
            completionHandler(Result.success(weather))
        }

        let api = ForecastApi.GetForecast(lat: location.coordinate.latitude, long: location.coordinate.longitude)
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
