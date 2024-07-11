// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

/// Client object
public class SynergiaClient {
    private var session: Request
    
    /// `classrooms` contains classrooms number for each subject/lesson. Key is classroom ID, value is classroom number
    private(set) public var classrooms: [String: String]!
    /// `subjects` contains subjects' names. Indexed by ID
    private(set) public var subjects: [String: String]!
    /// `users` contains information about school employees. Indexed by user's ID
    private(set) public var users: [String: User]!
    /// `lessons` contains information about lessons in school. Indexed by lesson ID
    private(set) public var lessons: [String: Lesson]!
    /// `colors` contains rgb values of colors. Indexed by color ID
    private(set) public var colors: [String: String]!
    
    /// Initializes client
    ///
    /// - Parameters:
    ///   - login: user's login as `String`
    ///   - password: user's password as `String`
    ///
    /// - Returns: `SynergiaClient`
    public init(login: String, password: String) async throws {
        let loginRequest = [
            "action": "login",
            "login": login,
            "pass": password]
            .toUrlEncoded()
        
        self.session = Request()
        _ = try await self.session.GET(Endpoints.authStep1)
        _ = try await self.session.POST(
            Endpoints.authStep2,
            body: loginRequest,
            contentType: "application/x-www-form-urlencoded"
        )
        _ = try await self.session.GET(Endpoints.authStep3)
        
        self.classrooms = try await self.getClassrooms()
        self.subjects = try await self.getSubjects()
        self.users = try await self.getUsers()
        self.lessons = try await self.getLessons()
        self.colors = try await self.getColors()
    }
    
    private func request<T: Decodable>(_ endpoint: String) async throws -> T {
        return try JSONDecoder().decode(
            T.self,
            from: await self.session.GET(Endpoints.apiGateway + endpoint)
        )
    }
    
    private func getSubjects() async throws -> [String: String] {
        let sub: SynergiaSubjects = try await self.request("Subjects")
        return sub.toDict()
    }
    
    private func getClassrooms() async throws -> [String: String] {
        let cls: SynergiaClassrooms = try await self.request("Classrooms")
        return cls.toDict()
    }
    
    private func getUsers() async throws -> [String: User] {
        let usrs: SynergiaUsers = try await self.request("Users")
        return usrs.toUserDict()
    }
    
    private func getLessons() async throws -> [String: Lesson] {
        let lsns: SynergiaLessons = try await self.request("Lessons")
        return lsns.toDict()
    }
    
    private func getColors() async throws -> [String: String] {
        let clrs: SynergiaColors = try await self.request("Colors")
        return clrs.toDict()
    }
    
    /// Gets information about the user
    /// - Returns: `Me` object
    public func getMe() async throws -> Me {
        let meRaw: SynergiaMe = try await self.request("Me")
        let clasRaw: SynergiaClass = try await self.request("Classes")
        
        let clas = Class(clasRaw.Class, users: self.users)
        let me = Me(meRaw.Me, Class: clas)
        return me
    }
    
    /// Gets grades
    /// - Returns: array of`Grades` dictionary indexed by subject's name
    public func getGrades() async throws -> [String: [Grade]] {
        let categoriesUnwrapped: SynergiaGradesCategories = try await self.request("Grades/Categories")
        let categories = categoriesUnwrapped.Categories
        let commentsRaw: SynergiaGradesComment = try await self.request("Grades/Comments")
        
        let gradesRaw: SynergiaGrades = try await self.request("Grades")
        
        var grades = [String: [Grade]]()
        gradesRaw.Grades.forEach { grade in
            if let category = categories.first(where: { $0.Id == grade.Category.Id }) {
                let grade = Grade(
                    category: category,
                    grade: grade,
                    comment: commentsRaw.getCommentById(grade.Id),
                    users: self.users,
                    subjects: self.subjects,
                    colors: self.colors
                )
                
                if grades[grade.subject] == nil {
                    grades[grade.subject] = []
                }
                grades[grade.subject]?.append(grade)
            }
        }
        
        return grades
    }
    
    /// Gets lucky number
    /// - Returns: lucky number as `UInt8`
    public func getLuckyNumber() async throws -> UInt8 {
        let l: SynergiaLuckyNumber = try await self.request("LuckyNumbers")
        return l.LuckyNumber.LuckyNumber
    }
    
    /// Gets timetable and returns it in this format:
    /// - Parameter weekStart: optional parameter to specify date starting the week
    /// - Returns: Date indexed dictionary of array of optional `TimetableItem`s
    /// ```
    /// [
    ///     "<year>-<month>-<day>": [
    ///         index 0: <lesson 0, nil if there is no lesson>,
    ///         index 1: <lesson 1, nil if there is no lesson>
    ///     ],
    ///     "<year>-<month>-<day>": [...],
    ///     ...
    /// ]
    /// ```
    ///
    public func getTimetable(_ weekStart: Date? = nil) async throws -> [String: [TimetableItem?]] {
        let timetableRaw: SynergiaTimetable = try await self.request("Timetables")
        
        var timetable = [String: [TimetableItem?]]()
        timetableRaw.Timetable.forEach { day, lessons in
            timetable[day] = [TimetableItem?]()
            lessons.forEach { lesson in
                var timetableItem: TimetableItem? = nil
                if lesson.count > 0 {
                    timetableItem = TimetableItem(lesson[0], day: day)
                    
                    let classroomId = lesson[0].Classroom.Id
                    if let classroom = self.classrooms[classroomId] {
                        timetableItem!.classroom = classroom
                    }
                }
                
                timetable[day]?.append(timetableItem)
            }
        }
        
        return timetable
    }
    
    /// Returns attendances list. Indexed by date formated into `year-month-day`
    public func getAttendances() async throws -> [String: [Attendance]] {
        let attTypes: SynergiaAttendanceTypes = try await self.request("Attendances/Types")
        let attRaw: SynergiaAttendances = try await self.request("Attendances")
        
        return attRaw.Attendances.reduce(into: [String: [Attendance]]()) { dict, attendance in
            if dict[attendance.Date] == nil {
                dict[attendance.Date] = []
            }
            
            guard let att = Attendance.new(attendance: attendance, types: attTypes, colors: self.colors) else { return }
            dict[attendance.Date]?.append(att)
        }
    }
}
