import Foundation

struct City {
    var id: Int?
    var name: String?
}

extension City {

    init?(json: [String: Any]) {
        if let id = json["id"] as? Int {
            self.id = id
        }

        if let name = json["name"] as? String {
            self.name = name
        }
    }
}
