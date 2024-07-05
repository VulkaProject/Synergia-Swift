import Foundation

struct SynergiaLuckyNumber: Decodable {
    struct LuckyNumber: Decodable {
        var LuckyNumber: UInt8
        var LuckyNumberDay: String
    }
    
    var LuckyNumber: LuckyNumber
}
