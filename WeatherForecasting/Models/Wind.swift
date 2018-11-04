
struct Wind {

    var speed: Double?
    var deg: Double?
}

extension Wind {

    init?(json: [String: Any]) {
        if let speed = json["speed"] as? Double {
            self.speed = speed
        }

        if let deg = json["deg"] as? Double {
            self.deg = deg
        }
    }
}
