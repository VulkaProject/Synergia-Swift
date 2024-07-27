import Foundation

struct SynergiaTimetable: Decodable {
    struct SynergiaTimetableItem: Decodable {
        var Lesson: IdStringAndUrl
        var Classroom: IdStringAndUrl
        var DateFrom: String
        var DateTo: String
        var LessonNo: String
        var TimetableEntry: IdStringAndUrl
        var DayNo: String
        var Subject: SynergiaSubject
        var Teacher: SynergiaTeacher
        var IsSubstitutionClass: Bool
        var IsCanceled: Bool
        var HourFrom: String
        var HourTo: String
        var VirtualClass: IdAndUrl?
        var VirtualClassName: String?
    }
    
    typealias Timetable = [String: [[SynergiaTimetableItem]]]
    var Timetable: Timetable
}

/// Entry in timetable
public final class TimetableItem {
    /// Subject name
    public var subject: String
    /// Teacher's name
    public var teacher: String
    /// If the event was canceled
    public var isCanceled: Bool
    /// Starts at
    public var startsAt: String
    /// Ends at
    public var endsAt: String
    /// Classroom
    public var classroom: String = ""
    
    init(_ timetable: SynergiaTimetable.SynergiaTimetableItem) {
        self.subject = timetable.Subject.Name
        self.teacher = timetable.Teacher.FirstName + " " + timetable.Teacher.LastName
        self.isCanceled = timetable.IsCanceled
        self.startsAt = timetable.HourFrom
        self.endsAt = timetable.HourTo
    }
}
