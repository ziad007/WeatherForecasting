
import Foundation

struct WeatherData {

    var weather: Weather?
    var main: Main?
    var sys: Sys?
    var wind: Wind?
    var visibility: Double?
    var name: String?
    var dt = Date()

    var dayInWeek: String {
      return DateFormatter.dayOfWeekDateFormatter.string(from: dt)
    }

    var time: String {
        return DateFormatter.hourDateFormatter.string(from: dt)
    }

    var isToday: Bool {
        return Calendar.current.isDate(dt, inSameDayAs:Date())
    }
}

extension WeatherData {

    init?(json: NSDictionary) {
        self.init()

        if let visibility = json["visibility"] as? Double {
            self.visibility = visibility
        }

        if let dt = json["dt"] as? Int64 {
            self.dt = Date(timeIntervalSince1970: TimeInterval(dt))
        }

        if let name = json["name"] as? String {
            self.name = name
        }

        if let weatherContainer = json["weather"] as? [[String: Any]]  {
            self.weather = Weather(json: weatherContainer)
        }

        if let mainContainer = json["main"] as? [String: Any] {
            self.main = Main(json: mainContainer)
        }

        if let windContainer = json["wind"] as? [String: Any] {
            self.wind = Wind(json: windContainer)
        }
        if let sysContainer = json["sys"] as? [String: Any] {
            self.sys = Sys(json: sysContainer)
        }
    }
}
