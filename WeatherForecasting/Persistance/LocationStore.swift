

import Foundation
import CoreLocation

final class LocationStore {
    static let shared = LocationStore()

    func getLocation() -> CLLocation? {
        if let data = UserDefaults.standard.data(forKey: "LOCATION"){
            do {
                if let locationDecoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? CLLocation {
                    return locationDecoded
                } else {
                    return nil

                }
            } catch {  return nil }
        } else {
             return nil
        }

    }

    func saveLocation(for location: CLLocation) -> Bool {
        do {
            let locData = try NSKeyedArchiver.archivedData(withRootObject: location, requiringSecureCoding: false)
            UserDefaults.standard.set(locData, forKey: "LOCATION")
            UserDefaults.standard.synchronize()
            return true
        } catch { return false }
    }
}
