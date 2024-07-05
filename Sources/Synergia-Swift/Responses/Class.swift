import Foundation

struct SynergiaClass: Decodable {
    struct Class: Decodable {
        var Id: UInt64
        var Number: Int
        var Symbol: String
        var BeginSchoolYear: String
        var EndFirstSemester: String
        var EndSchoolYear: String
        var Unit: IdAndUrl
        var ClassTutor: IdAndUrl
        var ClassTutors: [IdAndUrl]
    }
    
    var Class: Class
}

/// Stores information about school class the user belongs to
public final class Class {
    /// Class name (number + symbol, example: 1A, 2B, 3C)
    public var name: String
    /// Class tutors
    public var classTutors: [String]
    /// Date of the school year's start
    public var beginSchoolYear: Date
    /// Date of the school's first semester end
    public var endFirstSemester: Date
    /// Date of the school's year end
    public var endSchoolYear: Date
    
    init(_ Class: SynergiaClass.Class, users: [String: User]) {
        self.name = String(Class.Number) + Class.Symbol
        self.classTutors = []
        if let tutor0 = users[String(Class.ClassTutor.Id)] {
            self.classTutors.append(tutor0.name)
        }
        
        for tutor in Class.ClassTutors {
            if let tutor = users[String(tutor.Id)] {
                self.classTutors.append(tutor.name)
            }
        }
        
        self.beginSchoolYear = Class.BeginSchoolYear.toDateOnlyDayMonthAndYear() ?? Date()
        self.endFirstSemester = Class.EndFirstSemester.toDateOnlyDayMonthAndYear() ?? Date()
        self.endSchoolYear = Class.EndSchoolYear.toDateOnlyDayMonthAndYear() ?? Date()
    }
}
