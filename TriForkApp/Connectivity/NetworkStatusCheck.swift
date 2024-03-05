import Foundation
import SwiftUI

struct NetworkStatusCheck: View {
    
    @EnvironmentObject var networkReachability: NetworkReachability
  
    var body: some View {
        VStack {
            if !networkReachability.isConnected  {
                Text("No internet connection: once you have internet connection, the app will load the repositories.")
                    .font(.system(size: 14))
                    .padding(.bottom, 10)
                    .padding(.horizontal, 30)
                Image(systemName: "wifi.slash")
                    .padding(.top, 10)
            }
        }
        .font(.largeTitle)
        .onAppear {
            networkReachability.start()
        }
    }
}

