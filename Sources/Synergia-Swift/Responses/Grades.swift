import Foundation

struct SynergiaGrades: Decodable {
    struct Grade: Decodable {
        var Id: UInt64
        var Lesson: IdAndUrl
        var Subject: IdAndUrl
        var Student: IdAndUrl
        var Category: IdAndUrl
        var AddedBy: IdAndUrl
        var Grade: String
        var Date: String
        var AddDate: String
        var Semester: UInt64
        var IsConstituent: Bool
        var IsSemester: Bool
        var IsSemesterProposition: Bool
        var IsFinal: Bool
        var IsFinalProposition: Bool
    }
    
    var Grades: [Grade]
}

/// Stores information about grade
public class Grade {
    /// Grade type
    public enum GradeType {
        case constituent
        case final
        case finalProposal
        case semestral
        case semestralProposal
        
        init(grade: SynergiaGrades.Grade) {
            if grade.IsConstituent {
                self = .constituent
            } else if grade.IsFinal {
                self = .final
            } else if grade.IsFinalProposition {
                self = .finalProposal
            } else if grade.IsSemester {
                self = .semestral
            } else if grade.IsSemesterProposition {
                self = .semestralProposal
            }
            
            self = .constituent
        }
    }
    
    /// Grades ID (only used for Synergia)
    public var id: UInt64
    /// Grade
    public var grade: String
    /// Grade description
    public var comment: String?
    /// Semester when this grade was added
    public var semester: UInt8
    /// Subject name
    public var subject: String
    /// Category (example: exam, activity, final, etc.)
    public var category: String
    /// Weight
    public var weight: UInt64
    /// Grade type, check `GradeType`
    public var gradeType: GradeType
    /// Teacher name
    public var teacher: String
    /// Date when this grade was added
    public var date: Date
    /// Color (TODO!)
    public var color: UInt8
    
    init(category: SynergiaGradesCategories.GradeCategory, grade: SynergiaGrades.Grade, comment: String?, users: [String: User], subjects: [String: String]) {
        self.id = grade.Id
        self.grade = grade.Grade
        self.comment = comment
        self.semester = UInt8(grade.Semester)
        self.subject = subjects[String(grade.Subject.Id)] ?? ""
        self.category = category.Name
        self.weight = category.Weight ?? 0
        self.gradeType = GradeType(grade: grade)
        self.teacher = users[String(grade.AddedBy.Id)]?.name ?? ""
        self.color = 0 // TODO!
        self.date = grade.AddDate.toDate() ?? Date()
    }
}
