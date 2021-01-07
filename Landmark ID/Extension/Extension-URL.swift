
import Foundation

fileprivate let googleAPIKey = "AIzaSyBUClAqYnoK5ya0jN-Yoz2OlFvyl4uPpoI"

extension URLRequest {
    
    // HTTPMethod
    
    public enum HTTPMethod: String {
            case get = "GET"
            case put = "PUT"
            case post = "POST"
            case delete = "DELETE"
            case head = "HEAD"
            case options = "OPTIONS"
            case trace = "TRACE"
            case connect = "CONNECT"
        }
    
    public var method: HTTPMethod? {
            get {
                guard let httpMethod = self.httpMethod else { return nil }
                let method = HTTPMethod(rawValue: httpMethod)
                return method
            }
            set {
                self.httpMethod = newValue?.rawValue
            }
        }
    
    // HTTP Headers
    
    enum HTTPHeaderField: String {
        case contentType = "Content-Type"
        case bundleIdentifier = "X-Ios-Bundle-Identifier"
    }

    enum ContentType: String {
        case json = "application/json"
        case charSet = "charset=UTF-8"
    }

    var standardHeaders: [String : String] {
        return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue, HTTPHeaderField.bundleIdentifier.rawValue: Bundle.main.bundleIdentifier ?? ""]
    }
    
    // Google URL Request

    static func getGoogleURLRequest() -> URLRequest {
        let url = "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)"
        return URLRequest(url: URL(string: url)!)
    }
}
