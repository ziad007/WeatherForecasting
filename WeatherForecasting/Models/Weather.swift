
import Foundation

enum IconList: String {

    case clearSkyDay = "01d"
    case clearSkyNight = "01n"

    case fewCloudsDay = "02d"
    case fewCloudsNight = "02n"

    case scatteredCloudsDay = "03d"
    case scatteredCloudsNight = "03n"

    case brokenCloudsDay = "04d"
    case brokenCloudsNight = "04n"

    case showerRainDay = "09d"
    case showerRainNight = "09n"

    case rainDay = "10d"
    case rainNight = "10n"

    case thunderstormDay = "11d"
    case thunderstormNight = "11n"

    case snowDay = "13d"
    case snowNight = "13n"

    case mistDay = "50d"
    case mistNight = "50n"

    var smallIconName: String {
        switch self {
        case .brokenCloudsDay:
            return "60x60 Broken Clouds (Day)"
        case .brokenCloudsNight:
            return "60x60 Broken Clouds (Night)"

        case .clearSkyDay:
            return "60x60 Clear Sky (Day)"
        case .clearSkyNight:
            return "60x60 Clear Sky (Night)"

        case .fewCloudsDay:
             return "60x60 Few Clouds (Day)"
        case .fewCloudsNight:
            return "60x60 Few Clouds (Night)"

        case .mistDay:
            return "60x60 Mist (Day)"
        case .mistNight:
            return "60x60 Mist (Night)"

        case .rainDay:
            return "60x60 Rain (Day)"
        case .rainNight:
            return "60x60 Rain (Night)"

        case .scatteredCloudsDay:
            return "60x60 Scattered Clouds (Day)"
        case .scatteredCloudsNight:
            return "60x60 Scattered Clouds (Night)"

        case .showerRainDay:
            return "60x60 Shower Rain (Day)"
        case .showerRainNight:
            return "60x60 Shower Rain (Night)"

        case .snowDay:
            return "60x60 Snow (Day)"
        case .snowNight:
            return "60x60 Snow (Night)"

        case .thunderstormDay:
            return "60x60 thunderstorm (Day)"
        case .thunderstormNight:
            return "60x60 thunderstorm (Night)"
        }

    }

        var largeIconName: String {
            switch self {
            case .brokenCloudsDay:
                return "100x100 Broken Clouds (Day)"
            case .brokenCloudsNight:
                return "100x100 Broken Clouds (Night)"

            case .clearSkyDay:
                return "100x100 Clear Sky (Day)"
            case .clearSkyNight:
                return "100x100 Clear Sky (Night)"

            case .fewCloudsDay:
                return "100x100 Few Clouds (Day)"
            case .fewCloudsNight:
                return "100x100 Few Clouds (Night)"

            case .mistDay:
                return "100x100 Mist (Day)"
            case .mistNight:
                return "100x100 Mist (Night)"

            case .rainDay:
                return "100x100 Rain (Day)"
            case .rainNight:
                return "100x100 Rain (Night)"

            case .scatteredCloudsDay:
                return "100x100 Scattered Clouds (Day)"
            case .scatteredCloudsNight:
                return "100x100 Scattered Clouds (Night)"

            case .showerRainDay:
                return "100x100 Shower Rain (Day)"
            case .showerRainNight:
                return "100x100 Shower Rain (Night)"

            case .snowDay:
                return "100x100 Snow (Day)"
            case .snowNight:
                return "100x100 Snow (Night)"

            case .thunderstormDay:
                return "100x100 thunderstorm (Day)"
            case .thunderstormNight:
                return "100x100 thunderstorm (Night)"

            }
    }

}

struct Weather {
    var id: Int?
    var main: String?
    var temp: Double?
    var description: String?
    var icon: IconList?

    var iconURL: String {
        guard let icon = icon else { return "" }
        return "https://openweathermap.org/img/w/\(icon).png"
    }

    var temperatureCelcius: String {
        guard let temp = temp else { return "" }
        let tempCelcius: Double = temp - 273.15

        return "\(tempCelcius) C"
    }
}

extension Weather {

    init?(json: [[String: Any]]) {


        for weather in json {
            if let main = weather["main"] as? String {
                self.main = main
            }
            if let id = weather["id"] as? Int {
                self.id = id
            }
            if let icon = weather["icon"] as? String {
                self.icon = IconList(rawValue: icon)
            }
            if let description = weather["description"] as? String {
                self.description = description
            }
        }
    }
}
