import Foundation

public class UserInfo {
    public let name: String
    public let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

enum UserInfoError: Error {
    case fetchError
}
