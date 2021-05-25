//
//  DetailViewController.swift
//  _idx_Sources_3FF57295_ios_min9.0
//
//  Created by xinzheng zhang on 2021/5/25.
//

import Foundation
import UIKit
import RxRelay
import RxCocoa
import RxSwift
import Stevia

class DetailViewController : UIViewController {
    private let disposeBag = DisposeBag()
    var mid: Int
    var followed: BehaviorRelay<Bool>

    init(mid: Int, followed: BehaviorRelay<Bool>) {
        self.mid = mid
        self.followed = followed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var midLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "mid: \(mid)"
        return label
    }()
    
    private lazy var followedBtn: UIButton = {
        return UIButton(type: .custom)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.subviews {
            midLabel
            followedBtn
        }

        view.layout {
            |-midLabel-|
            |-followedBtn-|
        }

        followedBtn.centerHorizontally().centerVertically()
        
        followed.map { $0 ? "unfollow" : "follow"}.bind(to: followedBtn.rx.title()).disposed(by: disposeBag)
        followedBtn.rx.tap.bind(to: Binder<Void>(self) { me, Void in
            me.followed.accept(!me.followed.value)
        }).disposed(by: disposeBag)
    }
}
