import Foundation
import Combine

final public class UserInfoViewModel: ObservableObject {
    @Published private(set) var userInfo: UserInfo = UserInfo(name: "", age: 0)
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isCampaignTarget: Bool = false
    
    private let repo: UserInfoRepository
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        repo = UserInfoRepository()
        
        repo.errorMessagePublisher.sink{ val in
            print("エラーポップアップ表示:", val)
        }.store(in: &cancellables)

        repo.userInfoPublisher.sink{ userInfo in
            if let userInfo = userInfo {
                self.userInfo = userInfo
                self.isLoading = false
            } else {
                self.isLoading = true
            }
        }.store(in: &cancellables)

        repo.userInfoPublisher
            .compactMap { $0 } // nilの除去
            .filter { $0.name != "fukushima" }
            .map { $0.age + 10 } // 加工（後続には年齢+10の数値が流れる）
            .sink {
                self.isCampaignTarget = $0 > 50
            }.store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
    func refresh(id: Int, isSuccess: Bool) {
        repo.fetchUserInfo(id: id, isSuccess: isSuccess)
    }
}

