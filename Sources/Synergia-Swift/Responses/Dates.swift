import Foundation

extension String {
    func toDate(withoutSeconds: Bool = false) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" + (!withoutSeconds ? ":ss" : "")
        return dateFormatter.date(from: self)
    }
    
    func toDateOnlyDayMonthAndYear() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func formatOnlyDayMonthAndYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
