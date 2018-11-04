
import Foundation

class WeatherData: NSObject, NSCoding {

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

    struct PropertyKey {
        static let weather = "weather"
        static let main = "main"
        static let sys = "sys"
        static let wind = "wind"
        static let visibility = "visibility"
        static let name = "name"
        static let dt = "dt"
    }

    convenience init(weather: Weather, main: Main, sys: Sys?, wind: Wind?, visibility: Double?, name: String?, dt: Date) {
        self.init()
        self.weather = weather
        self.main = main
        self.sys = sys
        self.wind = wind
        self.visibility = visibility
        self.name = name
        self.dt = dt
    }

    //MARK: NSCoding

    func encode(with aCoder: NSCoder) {
        aCoder.encode(weather, forKey: PropertyKey.weather)
        aCoder.encode(main, forKey: PropertyKey.main)
        aCoder.encode(sys, forKey: PropertyKey.sys)
        aCoder.encode(wind, forKey: PropertyKey.wind)
        aCoder.encode(visibility, forKey: PropertyKey.visibility)
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(dt, forKey: PropertyKey.dt)
    }

    required convenience init?(coder aDecoder: NSCoder) {

        guard let weather = aDecoder.decodeObject(forKey: PropertyKey.weather) as? Weather else {
            return nil
        }

        guard let main = aDecoder.decodeObject(forKey: PropertyKey.main) as? Main else {
            return nil
        }

         let sys = aDecoder.decodeObject(forKey: PropertyKey.sys) as? Sys
         let wind = aDecoder.decodeObject(forKey: PropertyKey.wind) as? Wind
         let visibility = aDecoder.decodeObject(forKey: PropertyKey.visibility) as? Double
         let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
         let dt = aDecoder.decodeObject(forKey: PropertyKey.dt) as? Date

        self.init(weather: weather, main: main, sys: sys, wind: wind, visibility: visibility, name: name, dt: dt ?? Date())
    }
}

extension WeatherData {

    convenience init?(json: NSDictionary) {
        self.init()

        if let visibility = json["visibility"] as? Double {
            self.visibility = visibility
        }

        if let dt = json["dt"] as? Int64 {
            self.dt = Date(timeIntervalSince1970: TimeInterval(dt))
        }

        if let name = json["visibility"] as? String {
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
