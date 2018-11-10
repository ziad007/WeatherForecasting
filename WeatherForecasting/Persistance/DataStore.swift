import Foundation

enum DataStoreType {
    case weather
    case forecast
    case location

    var key: String {
        switch self {
        case .weather:
            return "weather"
        case .forecast:
            return "forecast"
        case .location:
            return "location"
        }
    }
}

final class DataStore {
    static let shared = DataStore()

    func getData(for mode: DataStoreType) -> NSDictionary? {
        if let data = UserDefaults.standard.object(forKey: mode.key) {
            return data as? NSDictionary
        } else {
            return nil
        }
    }

    func save(data: NSDictionary, for mode: DataStoreType) {
        UserDefaults.standard.set(data, forKey: mode.key)
        UserDefaults.standard.synchronize()
        FireBaseStore.shared.save(for: data, for: mode.key)
    }
}
