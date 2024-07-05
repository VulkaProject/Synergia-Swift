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
    /// Lesson number
    public var lessonNo: UInt8
    /// Subject name
    public var subject: String
    /// Teacher's name
    public var teacher: String
    /// If the event was canceled
    public var isCanceled: Bool
    /// Date of the start
    public var dateStarts: Date
    /// Date of the end
    public var dateEnds: Date
    /// Classroom
    public var classroom: String = ""
    
    init(_ timetable: SynergiaTimetable.SynergiaTimetableItem, day: String) {
        self.lessonNo = UInt8(timetable.LessonNo) ?? 0
        self.subject = timetable.Subject.Name
        self.teacher = timetable.Teacher.FirstName + " " + timetable.Teacher.LastName
        self.isCanceled = timetable.IsCanceled
        self.dateStarts = (day + " " + timetable.HourFrom).toDate(withoutSeconds: true) ?? Date()
        self.dateEnds = (day + " " + timetable.HourTo).toDate(withoutSeconds: true) ?? Date()
    }
}
