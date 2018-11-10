
import Foundation

typealias ForecastResponse = (Result<Forecast?, NSError>) -> Void

protocol ForecastServiceProtocol {
    func getForecast(for location: Location,
                     completionHandler: @escaping ForecastResponse)
}

final class ForecastService: ForecastServiceProtocol {
    let apiCall: APICall

    init(apiCall: APICall = APICall()) {
        self.apiCall = apiCall
    }

     func getForecast(for location: Location,
                      completionHandler: @escaping ForecastResponse) {

        if let forecastContainer = DataStore.shared.getData(for: .forecast) {
            let weather = Forecast(forecatDictionary: forecastContainer)
            completionHandler(Result.success(weather))
        }

        let api = ForecastApi.GetForecast(lat: location.lat, long: location.long)
        self.apiCall.sendRequest(api) { response in
            switch(response) {
            case .success(let result):
                guard let forecastContainer = result as? NSDictionary else { return }
                DataStore.shared.save(data: forecastContainer, for: .forecast)

                let weather = Forecast(forecatDictionary: forecastContainer)
                completionHandler(Result.success(weather))
            case .failure(let error):
                completionHandler(Result.failure(error as NSError))
            }
        }
    }
}
