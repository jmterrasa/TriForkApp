import SwiftUI
import Combine

class RepositoriesViewModel: ObservableObject {
    
    @Published var repositoriesByOwner: [Repository] = []
    var swappingRepositoriesByOwner: [Repository] = []
    @Published var organizations: GitHubOrganizationsResponse
    private let RepositoryFetcher: RepositoryFetchable
    private var cancellables: Set<AnyCancellable> = []
    var errorNetwork: NetworkError?
    var currentPage: Int = 1
    @Published var isError: Bool = false
    @Published var errorMessage: String? {
        didSet {
            isError = errorMessage != nil
        }
    }
    
    @Published var seekingOrg: String = ""
    private var disposables = Set<AnyCancellable>()
    
    init(RepositoryFetcher: RepositoryFetchable) {
        
        self.RepositoryFetcher = RepositoryFetcher
        self.organizations = GitHubOrganizationsResponse(totalCount: 0, incompleteResults: false, items: [])
       
        $seekingOrg
            .dropFirst(1)
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] inText in
                guard !inText.isEmpty else {
                    self?.currentPage = 1
                    self?.swappingRepositoriesByOwner = []
                    self?.repositoriesByOwner = []
                    return
                }
                
                self?.currentPage = 1
                self?.swappingRepositoriesByOwner = []
                self?.loadRepositoriesByOwner(ownerLogin: inText)
            }
            .store(in: &disposables)
    }
    
    func loadOrganizations() {
        
        RepositoryFetcher.fetchOrganizations(page: self.currentPage)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case .parsingError:
                        self.errorMessage = error.localizedDescription
                    case .networkError:
                        self.errorMessage = error.localizedDescription
                    }
                }
            }, receiveValue: { [weak self] newOrganizations in
                let limitedOrganizations = newOrganizations.items.prefix(15)
                self?.organizations.items.append(contentsOf:  limitedOrganizations)
            })
            .store(in: &cancellables)
    }
    
    func loadRepositoriesByOwner(ownerLogin: String) {
        
        RepositoryFetcher.fetchRepositoriesByOwner(ownerLogin: ownerLogin, page: self.currentPage)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case .parsingError:
                        self.errorMessage = error.localizedDescription
                    case .networkError:
                        self.errorMessage = error.localizedDescription
                    }
                }
            }, receiveValue: { [weak self] newRepositoriesByOwner in
                self?.swappingRepositoriesByOwner.append(contentsOf: newRepositoriesByOwner)
                self?.swappingRepositoriesByOwner = self?.swappingRepositoriesByOwner.removeDuplicatesInArray() ?? []
                print( "%d", self?.swappingRepositoriesByOwner.count ?? 0)
                self?.repositoriesByOwner = self?.swappingRepositoriesByOwner ?? []
            })
            .store(in: &cancellables)
    }
}

extension Array where Element == Repository {
    func removeDuplicatesInArray() -> [Repository] {
        var uniqueRepositories = Array(Set(self))
        uniqueRepositories = uniqueRepositories.sorted(by: { $0.size ?? 0 > $1.size ?? 0 })
        return uniqueRepositories
    }
}

