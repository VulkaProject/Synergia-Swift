import Foundation

struct SynergiaGradesComment: Decodable {
    struct Comment: Decodable {
        var Id: UInt64
        var AddedBy: IdAndUrl
        var Grade: IdAndUrl
        var Text: String
    }
    
    var Comments: [Comment]
    
    func getCommentById(_ id: UInt64) -> String? {
        return self.Comments.first(where: { $0.Grade.Id == id })?.Text
    }
}
