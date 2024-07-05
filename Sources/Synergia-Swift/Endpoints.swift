import Foundation

class Endpoints {
    static var authUrl = "https://api.librus.pl/OAuth/Authorization"
    static var authStep1 = authUrl + "?client_id=46&response_type=code&scope=mydata"
    static var authStep2 = authUrl + "?client_id=46"
    static var authStep3 = authUrl + "/2FA?client_id=46"
    
    static var apiGateway = "https://synergia.librus.pl/gateway/api/2.0/"
    
    static func timetables(_ weekStarts: Date? = nil) -> String {
        var endpoint = Self.apiGateway + "Timetables"
        if let weekStarts = weekStarts {
            endpoint += "?weekStart=" + weekStarts.formatOnlyDayMonthAndYear()
        }
        
        return endpoint
    }
}
