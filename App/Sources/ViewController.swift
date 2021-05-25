//
//  ViewController.swift
//  Frp_sample
//
//  Created by xinzheng zhang on 2021/5/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxFeedback
import RxRelay
import Stevia

fileprivate struct Up {
    let mid: Int
    let followed: BehaviorRelay<Bool>
}

extension RecommendError {
    var displayMessage: String {
        switch self {
        case .offline:
            return "no network"
        case .rpc_error(let http_code):
            return "http error: \(http_code)"
        }
    }
}

fileprivate struct State {
    var pageIndex: Int
    var should_next: Bool
    var results: [Up]
    var last_error: Error?
    var selectedUp: Up?
}

fileprivate enum Event {
    case initialize
    case reset
    case nextPage
    case response([Up], Error?)
    case select(IndexPath)
    case resetSelect
}

extension State {
    static var empty: State {
        return State(pageIndex: 0, should_next: true, results: [], last_error: nil)
    }
    static func reduce(state: State, event: Event) -> State {
        switch event {
        case .initialize:
            return State.empty
        case .reset:
            return State.empty
        case .nextPage:
            var result = state
            result.should_next = true
            return result
        case .response(let response, let error):
            var result = state
            result.should_next = false
            result.last_error = error
            result.results += response
            if error == nil {
                result.pageIndex += 1
            }
            return result
        case .select(let indexPath):
            var result = state
            result.selectedUp = state.results[indexPath.row]
            return result
        case .resetSelect:
            var result = state
            result.selectedUp = nil
            return result
        }
    }
}

extension State {
    var nextPageIndexRequest: Int? {
        return should_next ? pageIndex : nil
    }
}

class ViewController : UIViewController {

    private let disposeBag = DisposeBag()
    private var AssociatedObjectHandle: UInt8 = 0

    lazy var tableView: UITableView = {
        return UITableView(frame: view.frame, style: .plain)
    }()
    lazy var emptyLabel: UILabel = {
        return UILabel(frame: view.frame)
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .red
        emptyLabel.backgroundColor = .blue
        view.backgroundColor = .yellow
    
        view.subviews {
            tableView
            emptyLabel
        }

        view.layout {
            0
            |-tableView-|
            0
        }
        view.layout {
            0
            |-emptyLabel-|
            0
        }
        
        let jummper = Binder<Up>(self) { me, up in
            let target = DetailViewController(mid: up.mid, followed: up.followed)
            target.modalPresentationStyle = .popover
            me.present(target, animated: true, completion: nil)
        }
        
        let configureCell = { (tableView: UITableView, row: Int, up: Up) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "VideoCell")
            cell.textLabel?.text = String(up.mid)
            let dispose = up.followed.map { $0 ? "followed" : "unfollowed" }.bind(to: cell.detailTextLabel!.rx.text)
            objc_setAssociatedObject(cell, &self.AssociatedObjectHandle, dispose, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            return cell
        }
        
        
        let bindUI: (Driver<State>) -> Signal<Event> = bind(self) { me, state in
            let subscriptions = [
                state.map { state -> String? in
                    if let error = state.last_error as? RecommendError, state.results.count == 0 {
                        return error.displayMessage
                    }
                    return nil
                }.drive(me.emptyLabel.rx.textOrHide),
                state.map { $0.results }.drive(me.tableView.rx.items)(configureCell),
                state.map { $0.selectedUp }.compactMap { $0 }.drive(jummper)
            ]

            let events: [Signal<Event>] = [
                state.flatMapLatest { state -> Signal<Event> in
                    if state.should_next {
                        return Signal.empty()
                    }
                    return me.tableView.rx.nearBottom
                        .skip(1)
                        .map { _ in Event.nextPage }
                },
                me.tableView.rx.itemSelected.asSignal().map { Event.select($0) },
                me.rx.methodInvoked(#selector(UIViewController.viewDidDisappear(_:))).asSignal(onErrorJustReturn: []).map { _ in Event.resetSelect },

                me.tableView.rx.delegate.methodInvoked(#selector(UITableViewDelegate.scrollViewDidScrollToTop(_:))).asSignal(onErrorJustReturn: []).map { _ in Event.reset }

            ]
            return Bindings(subscriptions: subscriptions, events: events)
        }
        
        Driver.system(
            initialState: State.empty,
            reduce: State.reduce,
            feedback:
                bindUI,
                react(request: { $0.nextPageIndexRequest }, effects: { index -> Signal<Event> in
                    return API.request(index: index).map { element -> Event in
                        let videos = element.map { return Up(mid: $0.0, followed: BehaviorRelay<Bool>.init(value: $0.1)) }
                        return Event.response(videos, nil)
                    }.asSignal(onErrorRecover: { Signal.just(Event.response([], $0)) })
                })
        )
        .drive()
        .disposed(by: disposeBag)
    }
    
}
