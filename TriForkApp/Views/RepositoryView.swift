import SwiftUI

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

private extension Optional where Wrapped == Int {
    func multiply(by factor: Int) -> Int {
        return self ?? 0 * factor
    }
}
