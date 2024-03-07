import Foundation

struct GitHubOrganizationsResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    var items: [Organization]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct Organization: Codable, Identifiable, Equatable {
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: String
    let gravatar_id: String
    let url: String
    let html_url: String
    let followers_url: String
    let following_url: String
    let gists_url: String
    let starred_url: String
    let subscriptions_url: String
    let organizations_url: String
    let repos_url: String
    let events_url: String
    let received_events_url: String
    let type: String
    let site_admin: Bool
    let score: Double
}

struct Repository: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let node_id, name, full_name: String
    let owner: Owner
    let isPrivate: Bool
    let html_url, description: String?
    let fork: Bool
    let url, forks_url, keys_url, collaborators_url: String
    let teams_url, hooks_url, issue_events_url, events_url: String
    let assignees_url, branches_url, tags_url, blobs_url: String
    let git_tags_url, git_refs_url, trees_url, statuses_url: String
    let languages_url, stargazers_url, contributors_url, subscribers_url: String
    let subscription_url, commits_url, git_commits_url, comments_url: String
    let issue_comment_url, contents_url, compare_url, merges_url: String
    let archive_url, downloads_url, issues_url, pulls_url: String
    let milestones_url, notifications_url, labels_url, releases_url: String
    let deployments_url: String
    let size: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case node_id
        case name
        case full_name
        case owner
        case isPrivate = "private"
        case html_url
        case description
        case fork
        case url
        case forks_url
        case keys_url
        case collaborators_url
        case teams_url
        case hooks_url
        case issue_events_url
        case events_url
        case assignees_url
        case branches_url
        case tags_url
        case blobs_url
        case git_tags_url
        case git_refs_url
        case trees_url
        case statuses_url
        case languages_url
        case stargazers_url
        case contributors_url
        case subscribers_url
        case subscription_url
        case commits_url
        case git_commits_url
        case comments_url
        case issue_comment_url
        case contents_url
        case compare_url
        case merges_url
        case archive_url
        case downloads_url
        case issues_url
        case pulls_url
        case milestones_url
        case notifications_url
        case labels_url
        case releases_url
        case deployments_url
        case size
    }
    
    static func ==(lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Owner: Codable {
    let login: String
    let id: Int
    let node_id, avatar_url, url, html_url: String
    let followers_url, following_url, gists_url, starred_url: String
    let subscriptions_url, organizations_url, repos_url, events_url: String
    let received_events_url: String
    let type: String
    let site_admin: Bool
}

