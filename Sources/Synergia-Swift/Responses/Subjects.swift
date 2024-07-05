import Foundation

struct SynergiaSubjects: Decodable {
    struct Subject: Decodable {
        var Id: UInt64
        var Name: String
        var No: UInt64
        var Short: String
        var IsExtracurricular: Bool
        var IsBlockLesson: Bool
    }
    
    var Subjects: [Subject]
    
    func toDict() -> [String: String] {
        return self.Subjects.reduce(into: [String: String]()) {
            $0[String($1.Id)] = $1.Name
        }
    }
}
