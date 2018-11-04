
import Foundation

final class ForecastApi {
    struct GetForecast: RequestApi {
        let path = "forecast"
        let format: ResponseFormat = .json
        let lat: Double
        let long: Double
        let akmethod: HTTPMethods = .get
        var queryString: String? {
            return "?lat=\(lat)&lon=\(long)"
        }
    }
}
