import Foundation

struct SynergiaClassrooms: Decodable {
    struct Classroom: Decodable {
        var Id: UInt64
        var Name: String
        var Symbol: String
        var Size: UInt64
        var SchoolCommonRoom: Bool
    }
    
    var Classrooms: [Classroom]
    
    func toDict() -> [String: String] {
        return self.Classrooms.reduce(into: [String: String]()) {
            $0[String($1.Id)] = $1.Name
        }
    }
}
