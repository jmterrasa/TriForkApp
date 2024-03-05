import SwiftUI

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
