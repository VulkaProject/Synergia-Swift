import Foundation

struct SynergiaUsers: Decodable {
    struct SynergiaUser: Decodable {
        var Id: UInt64
        var AccountId: String
        var FirstName: String
        var LastName: String
        var IsSchoolAdministrator: Bool?
        var IsEmployee: Bool?
        var GroupId: Int
    }
    
    var Users: [SynergiaUser]
    
    func toUserDict() -> [String: User] {
        return self.Users.reduce(into: [String: User]()) {
            $0[String($1.Id)] = User($1)
        }
    }
}

/// Information about other Synergia users, mainly school employees
public final class User {
    /// User type
    public enum UserType: Int {
        case unknown = 0
        case unknown1 = 1
        case administrator = 2
        case principal = 3
        case employee = 4
    }
    
    /// User's name
    public var name: String
    /// User type, check `UserType`
    public var userType: UserType
    
    init(_ user: SynergiaUsers.SynergiaUser) {
        self.name = user.FirstName + " " + user.LastName
        self.userType = UserType(rawValue: user.GroupId) ?? .unknown
    }
}
