import Foundation

package actor NonReentrantActor {
    enum Status {
        case InProgress(Task<String, Error>)
        case Finished
    }

    var status: Status = .Finished

    func run(_ no: Int) async throws -> String {
        if case let .InProgress(task) = status {
            let v = try await task.value
            try Task.checkCancellation()
//            print("second", no)
            return v
        }
        let task = Task.init {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            return "hello \(Int.random(in: 0..<1000))"
        }
        status = .InProgress(task)
        let v = try await task.value
        status = .Finished
        try Task.checkCancellation()
//        print("first", no)
        return v
    }
    func cancel() {
        if case let .InProgress(t) = status {
            t.cancel()
            status = .Finished
        }
    }
}
