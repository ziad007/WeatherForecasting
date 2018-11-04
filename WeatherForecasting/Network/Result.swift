
import Foundation

public enum Result<T, Error: NSError> {
    case success(T)
    case failure(NSError)
}
