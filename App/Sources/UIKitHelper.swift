import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UITableView {
    
    var nearBottom: Signal<()> {
        func isNearBottomEdge(tableView: UITableView, edgeOffset: CGFloat = 20.0) -> Bool {
            return tableView.contentOffset.y + tableView.frame.size.height + edgeOffset > tableView.contentSize.height
        }
        
        return self.contentOffset.asDriver()
            .flatMap { _ in
                return isNearBottomEdge(tableView: self.base, edgeOffset: 20.0)
                    ? Signal.just(())
                    : Signal.empty()
        }
    }
}

extension Reactive where Base: UILabel {
    var textOrHide: Binder<String?> {
        return Binder(base) { label, value in
            guard let value = value else {
                label.isHidden = true
                return
            }

            label.text = value
            label.isHidden = false
        }
    }
}
