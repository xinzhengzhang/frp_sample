import Foundation
import RxSwift

let pageSize: Int = 20
enum RecommendError: Error {
    case offline
    case rpc_error(Int)
}

struct API {
    static func request(index: Int) -> Observable<[(Int, Bool)]> {
        if Int.random(in: 1..<5) == 1{
            return Observable.error(RecommendError.rpc_error(1024))
        } else {
            let result = (index * pageSize ..< (index + 1) * pageSize).map { ($0, Bool.random()) }
            return Observable<[(Int, Bool)]>.just(result).delay(.seconds(1), scheduler: MainScheduler.instance)
        }
    }
}
