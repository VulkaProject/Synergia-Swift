import Foundation

struct SynergiaMe: Decodable {
    struct Me: Decodable {
        struct Account: Decodable {
            var Id: Int64
            var UserId: Int64
            var FirstName: String
            var LastName: String
            var Email: String
            var GroupId: Int64
            var IsActive: Bool
            var Login: String
        }
    
        struct User: Decodable {
            var FirstName: String
            var LastName: String
        }
        
        var Account: Account
        var Refresh: Int64
        var User: IdAndUrl
        var Class: IdAndUrl
    }
    
    var Me: Me
}

/// Information about the user
public final class Me {
    /// User's ID (only used for Synergia)
    public var id: String
    /// User's name
    public var name: String
    /// User's email
    public var email: String
    /// User's synergia login
    public var login: String
    /// Information about the class the user belongs to, check `Class`
    public var Class: Class
    
    init(_ me: SynergiaMe.Me, Class: Class) {
        self.id = String(me.Account.UserId)
        self.name = me.Account.FirstName + " " + me.Account.LastName
        self.email = me.Account.Email
        self.login = me.Account.Login
        self.Class = Class
    }
}
