import Foundation

struct SynergiaLessons: Decodable {
    struct SynergiaLesson: Decodable {
        var Id: UInt64
        var Teacher: IdAndUrl
        var Subject: IdAndUrl
        var Class: IdAndUrl?
    }
    
    var Lessons: [SynergiaLesson]
    
    func toDict() -> [String: Lesson] {
        return self.Lessons.reduce(into: [String: Lesson]()) {
            $0[String($1.Id)] = Lesson(
                teacherId: String($1.Teacher.Id),
                subjectId: String($1.Subject.Id),
                classId: $1.Class != nil ? String($1.Class!.Id) : nil
            )
        }
    }
}

/// Synergia lesson entry. Used mainly for library's internal processing
public final class Lesson {
    /// Teacher's ID
    public var teacherId: String
    /// Subject ID
    public var subjectId: String
    /// Class ID
    public var classId: String?
    
    init(teacherId: String, subjectId: String, classId: String?) {
        self.teacherId = teacherId
        self.subjectId = subjectId
        self.classId = classId
    }
}
