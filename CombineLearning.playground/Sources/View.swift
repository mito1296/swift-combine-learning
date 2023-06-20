import Foundation
import Combine
import SwiftUI

let FetchUserInfoEvent = [
    (1, true),
    (2, false),
    (2, true),
    (3, true),
    (4, true),
    (4, false),
    (5, true),
    (6, true),
    ]

// SwiftUIでつかうときはViewを継承する
public class UserInfoView {
    // SwiftUIで使うときは@StateObjectをつける
    private var viewModel = UserInfoViewModel()
    
    public init() {}
    
    // ユーザーイベントごとの画面描画のシミュレート
    // 仕様は下記
    // repo.userInfoにデータがあるときは表示、nilのときはローディングする
    // fukushimaさん以外の10年後に50歳以上のユーザーにキャンペーンバナーを表示する
    public func run() {
        for (i, v) in FetchUserInfoEvent.enumerated() {
            print("==== Step.", i, "====")
            viewModel.refresh(id: v.0, isSuccess: v.1)
            
            if viewModel.isLoading {
                print("ローディング表示")
            } else {
                print("現在のユーザー情報表示: { name: \(viewModel.userInfo.name), age: \(viewModel.userInfo.age) }")
                if viewModel.isCampaignTarget {
                    print("キャンペーン中バナー表示")
                }
            }
            print("\n\n")
        }
    }
}
