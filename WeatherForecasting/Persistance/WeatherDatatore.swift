import Foundation
import CoreLocation

enum WeatherMode {
    case currentWeather
    case forecast

    var key: String {
        switch self {
        case .currentWeather:
            return "currentWeather"
        case .forecast:
            return "forecast"
        }
    }
}

final class WeatherDatatore {
    static let shared = WeatherDatatore()

    func getWeatherData(for mode: WeatherMode) -> NSDictionary? {
        if let data = UserDefaults.standard.object(forKey: mode.key) {
            return data as? NSDictionary
        } else {
            return nil
        }
    }

    func saveWeatherData(with weatherData: NSDictionary, for mode: WeatherMode) {
        UserDefaults.standard.set(weatherData, forKey: mode.key)
        UserDefaults.standard.synchronize()
    }
}
