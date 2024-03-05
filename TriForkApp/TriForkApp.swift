import SwiftUI

@main
struct TriForkApp: App {
   
    let fetcher = RepositoriesFetcher()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(RepositoriesViewModel(repositoriesFetcher: fetcher))
                .environmentObject(NetworkReachability())
        }
    }
}
