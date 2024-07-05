import Foundation

struct SynergiaGradesCategories: Decodable {
    struct GradeCategory: Decodable {
        var Id: Int64
        var Color: IdAndUrl
        var Name: String
        var AdultsExtramural: Bool
        var AdultsDaily: Bool
        var Standard: Bool
        var IsReadOnly: String
        var CountToTheAverage: Bool
        var Weight: Int64?
        var BlockAnyGrades: Bool
        var ObligationToPerform: Bool
        var IsFinal: Bool?
        var IsSemestral: Bool?
        var IsSemestralProposition: Bool?
        var IsFinalProposition: Bool?
        var IsSemestralInSchoolForAdults: Bool?
    }
    
    var Categories: [GradeCategory]
}
