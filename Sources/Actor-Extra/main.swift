import Foundation

let runner = NonReentrantActor()

Task.detached {
    try print(await runner.run(1))
}

// Task.detached {
//    try await Task.sleep(nanoseconds: 500_000_000)
//    await runner.cancel()
// }
Task.detached {
    try print(await runner.run(3))
}

Task.detached {
    try print(await runner.run(4))
}

Task {
    try print(await runner.run(5))
}

Thread.sleep(forTimeInterval: 3)
print("done")
