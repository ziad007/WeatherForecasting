
import Foundation

final class ForecastApi {
    struct GetForecast: RequestApi {
        let path = "forecast"
        let format: ResponseFormat = .json
        let lat: Double
        let long: Double
        let akmethod: HTTPMethods = .get
        var queryString: String? {
            return "?lat=\(lat)&lon=\(long)&APPID=5438d6ca9cbb89943826e67dabc61a78"
        }
    }
}
