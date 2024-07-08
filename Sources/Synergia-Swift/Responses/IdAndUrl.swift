import Foundation

struct IdAndUrl: Decodable {
    var Id: UInt64
    var Url: String
}

struct IdStringAndUrl: Decodable {
    var Id: String
    var Url: String
}

struct SynergiaSubject: Decodable {
    var Id: String
    var Name: String
    var Short: String
    var Url: String
}

struct SynergiaTeacher: Decodable {
    var Id: String
    var FirstName: String
    var LastName: String
    var Url: String
}
