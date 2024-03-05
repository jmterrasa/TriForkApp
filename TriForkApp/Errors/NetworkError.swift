
import Foundation

enum NetworkError: Error {
    case parsingError
    case networkError
}

extension NetworkError: LocalizedError {
   
    var errorDescription: String? {
        switch self {
        case .parsingError:
            return NSLocalizedString("A parsing error occurred.", comment: "")
        case .networkError:
            return NSLocalizedString("An API error occurred.", comment: "")
        }
    }
}
