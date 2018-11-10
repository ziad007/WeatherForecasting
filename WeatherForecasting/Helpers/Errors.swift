
import Foundation

enum ErrorCodes: Int {
    case limitExceeded = 403
    case restricted = 401

    case unknown

    init?(code: Int) {
        self.init(rawValue: code)
    }

    var message: String {
        switch self {

        case .limitExceeded:
            return "API rate limit exceeded"
        case .restricted:
            return "Restricted"
        default:
            return "Unknown Error"
        }
    }

    var error: NSError {
        return NSError(domain: message, code: self.rawValue, userInfo: nil)
    }
}
