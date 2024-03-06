import SwiftUI

@main
struct TriForkApp: App {
   
    let fetcher = RepositoryFetcher()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(RepositoriesViewModel(RepositoryFetcher: fetcher))
                .environmentObject(NetworkReachability())
        }
    }
}
