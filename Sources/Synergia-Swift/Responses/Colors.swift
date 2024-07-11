import Foundation

struct SynergiaColors: Decodable {
    struct SynergiaColor: Decodable {
        var Id: UInt64
        var RGB: String
        var Name: String
    }
    
    var Colors: [SynergiaColor]
    
    func toDict() -> [String: String] {
        return self.Colors.reduce(into: [String: String]()) {
            $0[String($1.Id)] = $1.RGB
        }
    }
}
