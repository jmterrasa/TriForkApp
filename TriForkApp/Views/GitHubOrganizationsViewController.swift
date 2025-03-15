import UIKit
import Combine

class GitHubOrganizationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var viewModel: RepositoriesViewModel!
    var isSearching = false
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "GitHub Organizations"
        self.view.backgroundColor = .white
        
        setupSearchBar()
        setupTableView()
        
        viewModel.loadOrganizations()
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search GitHub Organization"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            viewModel.repositoriesByOwner = []
            viewModel.loadOrganizations()
        } else {
            isSearching = true
            viewModel.seekingOrg = searchText
            viewModel.loadRepositoriesByOwner(ownerLogin: searchText)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? viewModel.repositoriesByOwner.count : viewModel.organizations.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isSearching {
            let repository = viewModel.repositoriesByOwner[indexPath.row]
            cell.textLabel?.text = repository.name
        } else {
            let organization = viewModel.organizations.items[indexPath.row]
            cell.textLabel?.text = organization.login
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isSearching {
            if indexPath.row == viewModel.repositoriesByOwner.count - 1 {
                viewModel.currentPage += 1
                viewModel.loadRepositoriesByOwner(ownerLogin: viewModel.seekingOrg)
            }
        } else {
            if indexPath.row == viewModel.organizations.items.count - 1 {
                viewModel.currentPage += 1
                viewModel.loadOrganizations()
            }
        }
    }
}
