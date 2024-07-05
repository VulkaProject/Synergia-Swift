import Foundation

class Request {
    var session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpCookieStorage?.cookies?.forEach { cookie in
            configuration.httpCookieStorage?.deleteCookie(cookie)
        }
        configuration.httpCookieAcceptPolicy = .always
        
        session = URLSession(configuration: configuration)
    }
    
    func GET(_ url: String) async throws -> Data {
        let (body, _) = try await self.session.data(from: URL(string: url)!)
//        print(String(decoding: body, as: UTF8.self), (response as? HTTPURLResponse)?.statusCode ?? 0)
        return body
    }
    
    func POST(_ url: String, body: Data, contentType: String) async throws -> Data {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let (body, _) = try await self.session.data(for: request)
//        print(String(decoding: body, as: UTF8.self), (response as? HTTPURLResponse)?.statusCode ?? 0)
        return body
    }
}

extension Dictionary {
    func toUrlEncoded() -> Data {
        return self.map { key, value in
            let encodedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let encodedVal = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return encodedKey + "=" + encodedVal
        }
        .joined(separator: "&")
        .data(using: .utf8) ?? Data()
    }
}
