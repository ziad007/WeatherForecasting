import Foundation
import UIKit

func ClassNameFromClass(_ aClass: AnyClass) -> String {
    return String(describing: aClass)
}

func ClassNameFromObject(_ object: AnyObject) -> String {
    return ClassNameFromClass(type(of: object))
}

func transformDateFromJSON(_ value: Any?) -> Date? {
    if let dateString = value as? UInt64 {
        let dateVal: Int = Int(dateString)
        return Date(timeIntervalSince1970: TimeInterval(dateVal))
    }
    return nil
}

