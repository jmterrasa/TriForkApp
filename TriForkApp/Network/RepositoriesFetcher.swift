import Foundation
import Combine
import Network

protocol RepositoryFetchable {
    func fetchOrganizations(page: Int) -> AnyPublisher<GitHubOrganizationsResponse, NetworkError>
    func fetchRepositoriesByOwner(ownerLogin: String, page: Int) -> AnyPublisher<[Repository], NetworkError>
}

class RepositoryFetcher {
    
    private let session: URLSession
    private var cancellables: Set<AnyCancellable> = []
    
    init(sesion: URLSession = .shared) {
        self.session = sesion
    }
}

// MARK: - RepositoryFetchable
extension RepositoryFetcher: RepositoryFetchable {
    
    func fetchOrganizations(page: Int) -> AnyPublisher<GitHubOrganizationsResponse, NetworkError> {
        return fetch(with: makeGitHubOrganizationsComponents(page: page))
    }
    
    func fetchRepositoriesByOwner(ownerLogin: String, page: Int) -> AnyPublisher<[Repository], NetworkError> {
        return fetch(with: makeGitHubRepositoriesByOwnerComponents(owner: ownerLogin, page: page))
    }
    
    private func fetch<T>(with components: URLComponents) -> AnyPublisher<T, NetworkError> where T: Decodable {
        
        guard let url = components.url else {
            let error = NetworkError.networkError
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("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", forHTTPHeaderField: "Authorization")
        //return session.dataTaskPublisher(for: URLRequest(url: url))
        return session.dataTaskPublisher(for: request)
            .mapError { error in
                    .networkError
            }
            .flatMap(maxPublishers: .max(1)) { pair in
                decode(pair.data)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - GitHubRepositories API
private extension RepositoryFetcher {
    
    struct GitHubRepositoriesAPI {
        static let scheme = "https"
        static let host = "api.github.com"
        static let path = "/repositories"
    }
    
    struct GitHubRepositoriesFromOrganizationAPI {
        static let path = "/orgs"
    }
    
    struct GitHubOrganizationsAPI {
        static let path = "/search"
    }
    
    func makeGitHubOrganizationsComponents(page: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = GitHubRepositoriesAPI.scheme
        components.host = GitHubRepositoriesAPI.host
        components.path = "\(GitHubOrganizationsAPI.path)/users"
        components.queryItems = [
            URLQueryItem(name: "q", value: "type:org"),
            URLQueryItem(name: "page", value: String(page)),
        ]
        
        return components
    }
    
    func makeGitHubRepositoriesByOwnerComponents(owner: String, page: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = GitHubRepositoriesAPI.scheme
        components.host = GitHubRepositoriesAPI.host
        components.path = "\(GitHubRepositoriesFromOrganizationAPI.path)/\(owner)/repos"
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(15)),
        ]
        
        return components
    }
}



