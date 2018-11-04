
import Foundation

final class WeatherApi {
    struct GetCurrentWeather: RequestApi {
        let path = "weather"
        let lat: Double
        let long: Double
        let format: ResponseFormat = .json
        let akmethod: HTTPMethods = .get
        var queryString: String? {
            return "?lat=\(lat)&lon=\(long)"
        }
    }
}
