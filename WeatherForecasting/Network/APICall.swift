
import Foundation
import UIKit

let SharedAPICall = APICall()
typealias response = Result<Any?, NSError>

let baseURLString = "https://api.openweathermap.org/data/2.5"

protocol RequestApi {
    var path: String { get }
    var format: ResponseFormat { get }
    var akmethod: HTTPMethods { get }
    var queryString: String? { get }
}

extension RequestApi {
    var completeURLString: String {
        return "\([baseURLString, path].joined(separator: "/"))\(queryString ?? "")"
    }
}

enum ResponseFormat: String {
    case json = "json"
}

enum HTTPMethods {
    case get, post, put, patch, delete

        var description: String {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .put:
                return "PUT"
            case .patch:
                return "PATCH"
            case .delete:
                return "DELETE"
            }
        }
    }


class APICall {

    func sendRequest<T: RequestApi>(
        _ API: T,
        handler: @escaping (response) -> Void)  {
        print(API.completeURLString)

        guard let url = URL(string: API.completeURLString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = API.akmethod.description

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in

            if error != nil {
                if let httpResponse = response as? HTTPURLResponse {
                    let responseError = ErrorCodes(code: httpResponse.statusCode)
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false

                        handler(Result.failure((responseError?.error)!))
                    }
                }
                return
            }

            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: [])

                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    handler(Result.success(json))
                    }
        }
        task.resume()
    }
}
