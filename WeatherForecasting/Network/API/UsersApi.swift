
import Foundation

final class WeatherApi {
    struct GetCurrentWeather: RequestApi {
        let path = "weather"
        let lat: Double
        let long: Double
        let format: ResponseFormat = .json
        let akmethod: HTTPMethods = .get
        var queryString: String? {
            return "?lat=\(lat)&lon=\(long)&APPID=5438d6ca9cbb89943826e67dabc61a78"
        }
    }
}
