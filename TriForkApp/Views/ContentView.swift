import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var networkMonitor: NetworkReachability
    
    var body: some View {
        if networkMonitor.isConnected {
            GitHubOrganizationsView()
        } else {
            NetworkStatusCheck()
        }
    }
}

#Preview {
    ContentView()
}
