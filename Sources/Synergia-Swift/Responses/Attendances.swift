import Foundation

struct SynergiaAttendances: Decodable {
    struct AttendanceItem: Decodable {
        var Lesson: IdAndUrl
        var Student: IdAndUrl
        var Trip: IdAndUrl?
        var Date: String
        var AddDate: String
        var LessonNo: UInt64
        var Semester: UInt8
        var `Type`: IdAndUrl
        var AddedBy: IdAndUrl
    }
    
    var Attendances: [AttendanceItem]
}

/// Attendance entry
public final class Attendance {
    /// Lesson number
    public var lessonNo: UInt64
    /// Day
    public var day: Date
    /// Full name (ex. "nieobecnosc")
    public var typeFull: String
    /// Short form (ex. "nb")
    public var typeShort: String
    /// Who added this entry
    public var addedBy: String
    /// Color
    public var colorRgb: String
    
    init(lessonNo: UInt64, day: Date, typeFull: String, typeShort: String, addedBy: String, colorRgb: String) {
        self.lessonNo = lessonNo
        self.day = day
        self.typeFull = typeFull
        self.typeShort = typeShort
        self.addedBy = addedBy
        self.colorRgb = colorRgb
    }
    
    static func new(attendance: SynergiaAttendances.AttendanceItem, types: SynergiaAttendanceTypes, colors: [String: String], users: [String: User]) -> Self? {
        guard
            let type = types.Types.first(where: { $0.Id == attendance.Type.Id }),
            type.Id != 100
        else { return nil }
        
        return Self(
            lessonNo: attendance.LessonNo,
            day: attendance.Date.toDateOnlyDayMonthAndYear() ?? Date(),
            typeFull: type.Name,
            typeShort: type.Short,
            addedBy: users[String(attendance.AddedBy.Id)]?.name ?? "",
            colorRgb: type.ColorRGB ?? colors[String(type.Color?.Id ?? 0)] ?? "000000"
        )
    }
}
