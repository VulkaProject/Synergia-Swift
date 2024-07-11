import Foundation

struct SynergiaAttendanceTypes: Decodable {
    struct `Type`: Decodable { // Type is reserved :(
        var Id: UInt64
        var Name: String
        var Short: String
        var Standard: Bool
        var ColorRGB: String?
        var StandardType: IdAndUrl?
        var Color: IdAndUrl?
        var IsPresenceKind: Bool
        var Order: UInt64
    }
    
    var Types: [Self.`Type`]
}
