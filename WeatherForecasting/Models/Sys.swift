import Foundation

struct Sys {
    var country: String?

    var countryFullName: String? {

        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: country ?? "") {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return country
        }
    }
}

extension Sys {

    init?(json: [String: Any]) {
        if let country = json["country"] as? String {
            self.country = country
        }
    }
}
