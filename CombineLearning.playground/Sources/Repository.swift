import Combine

class UserInfoRepository {
    
    private let dataSource = UserInfoDataSource()
    private var cancellables: Set<AnyCancellable> = []
    
    // 外部からsendできないようにprivateにする
    // 画面に表示するような状態を保持するものはCurrentValueSubject
    private let userInfoSubject = CurrentValueSubject<UserInfo?, Never>(nil)
    // エラーをトーストで表示する等、イベント終了後に状態が不要なものはPassthroughSubject
    private let errorMessageSubject = PassthroughSubject<String, Never>()
    
    // 現在の値を外部から参照できるようにする
    var userInfo: UserInfo? {
        get {
            userInfoSubject.value
        }
    }
    
    // 外部から購読できるようにする
    var userInfoPublisher: AnyPublisher<UserInfo?, Never> {
        get {
            userInfoSubject.eraseToAnyPublisher()
        }
    }
    var errorMessagePublisher: AnyPublisher<String, Never> {
        get {
            errorMessageSubject.eraseToAnyPublisher()
        }
    }
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
    // 関数経由でsendするように制限
    func fetchUserInfo(id: Int, isSuccess: Bool) {
        dataSource.fetchUserData(id: id, isSuccess: isSuccess)
            .sink() { result in
                switch result {
                case .success(let userInfo):
                    self.userInfoSubject.send(userInfo)
                case .failure:
                    self.errorMessageSubject.send("データ取得に失敗しました。")
                }
            }.store(in: &cancellables)
    }
    
}

// 上記と同じことができる
public class NeoUserInfoRepository {
    
    private let dataSource = UserInfoDataSource()
    private var cancellables: Set<AnyCancellable> = []
    
    // CurrentValueSubjectの代わりに@Publishedを使うとAnyPublisherや現在値の記述が不要になる
    // $userInfo.sinkで購読できる
    @Published private(set) var userInfo: UserInfo? = nil
    private let errorMessageSubject = PassthroughSubject<String, Never>()
    
    func fetchUserInfo(id: Int, isSuccess: Bool) {
        dataSource.fetchUserData(id: id, isSuccess: isSuccess)
            .sink() { result in
                switch result {
                case .success(let userInfo):
                    self.userInfo = userInfo
                case .failure:
                    self.errorMessageSubject.send("データ取得に失敗しました。")
                }
            }.store(in: &cancellables)
    }
}
