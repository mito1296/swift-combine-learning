import Foundation
import Combine

class UserInfoDataSource {
    func fetchUserData(id: Int, isSuccess: Bool) -> Future<Result<UserInfo?, UserInfoError>, Never> {
        // Future: 非同期で一つの値を生成して出力するか失敗するPublisher
        return Future() { promise in
            if isSuccess {
                promise(.success(.success(self.userInfoDB[id])))
            } else {
                promise(.success(.failure(UserInfoError.fetchError)))
            }
        }
    }
                        
    // 本来はAPIやDBから取得する想定
    private let userInfoDB = [
        nil,
        UserInfo(name: "chiba", age: 42),
        UserInfo(name: "osaka", age: 20),
        UserInfo(name: "ishikawa", age: 8),
        nil,
        UserInfo(name: "fukushima", age: 62),
        UserInfo(name: "kagawa", age: 55),
    ]
}
