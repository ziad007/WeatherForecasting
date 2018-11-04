
import Foundation

// MARK: - API Date Formatting
extension DateFormatter {

    /// A date formatter configured to accept ISO8610 date formats using the en_US_POSIX
    ///  locale and a UTC time zone. Suitable for parsing dates from the API.
    static let iso8601UTCDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }()

    static let isoUTCDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, yyyy"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }()

    static let dayOfWeekDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    static let hourDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

}
