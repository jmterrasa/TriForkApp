import SwiftUI
import Combine

struct GitHubOrganizationsView: View {
    
    @EnvironmentObject var viewModel: RepositoriesViewModel
    @State var isSearching = false
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Helvetica", size: 20)!]
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                TextField("Search GitHub Organization", text: $viewModel.seekingOrg, onEditingChanged: { isEditing in
                    if !isEditing && viewModel.seekingOrg == "" {
                        self.viewModel.repositoriesByOwner = []
                        self.isSearching = false
                        self.viewModel.loadOrganizations()
                        
                    }else if isEditing {
                        self.viewModel.organizations.items = []
                        self.isSearching = true
                        self.viewModel.currentPage = 1
                        self.viewModel.seekingOrg = ""
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                
                if !isSearching && self.viewModel.seekingOrg == "" {
                    withAnimation {
                        List(self.viewModel.organizations.items) { organization in
                            OrganizationView(organization: organization)
                                .onAppear {
                                    if self.viewModel.organizations.items.isLastItem(organization) {
                                        self.viewModel.currentPage += 1
                                        self.viewModel.loadOrganizations()
                                    }
                                }
                        }
                    }
                }else {
                    if self.isSearching {
                        withAnimation {
                            List(self.viewModel.repositoriesByOwner) { repository in
                                RepositoryView(repository: repository)
                                    .onAppear {
                                        if self.viewModel.repositoriesByOwner.isLastItem(repository) {
                                            self.viewModel.currentPage += 1
                                            self.viewModel.loadRepositoriesByOwner(ownerLogin: self.viewModel.seekingOrg)
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(self.isSearching ? "\(self.viewModel.seekingOrg) Repositories: \(self.viewModel.repositoriesByOwner.count)" : "GitHub Organizations: \(self.viewModel.organizations.items.count)")
        }
        .onAppear {
            self.viewModel.repositoriesByOwner = []
            self.viewModel.organizations.items = []
            self.isSearching = false
            self.viewModel.seekingOrg = ""
            self.viewModel.currentPage = 1
            self.viewModel.loadOrganizations()
        }
    }
}

// MARK: - Views
struct OrganizationView: View {
    
    var organization: Organization
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(organization.login)
                .font(.headline)
            Text("ID: \(organization.id)")
                .font(.subheadline)
            Text("URL: \(organization.url)")
                .font(.subheadline)
        }
    }
}

struct RepositoryView: View {
    
    var repository: Repository
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Owner: \(repository.owner.login)")
                .font(.headline)
            Text("Name: \(repository.name)")
                .font(.subheadline)
            Text("Desc: \(repository.description ?? "")")
                .font(.subheadline)
            Text("Size: \(repository.size.multiply(by: 1024)) Bytes")
                .font(.subheadline)
        }
    }
}

//MARK: - extensions
private extension Array where Element: Identifiable {
    func isLastItem(_ item: Element) -> Bool {
        guard let index = self.firstIndex(where: { $0.id == item.id }) else {
            return false
        }
        return index == self.count - 1
    }
}

private extension Optional where Wrapped == Int {
    func multiply(by factor: Int) -> Int {
        return self ?? 0 * factor
    }
}


