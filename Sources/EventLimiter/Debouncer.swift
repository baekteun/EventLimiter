import Foundation

public final class Debouncer {
    private let dueTime: UInt64
    private var task: Task<Void, Error>?

    public init(for dueTime: TimeInterval) {
        self.dueTime = UInt64(dueTime * 1_000_000_000)
    }

    deinit {
        self.cancel()
    }

    public func callAsFunction(action: @escaping () async throws -> Void) {
        self.execute(action: action)
    }

    public func cancel() {
        self.task?.cancel()
        self.task = nil
    }
}

private extension Debouncer {
    func execute(action: @escaping () async throws -> Void) {
        self.task?.cancel()
        self.task = Task { [dueTime] in
            try await Task.sleep(nanoseconds: dueTime)
            guard !Task.isCancelled else { return }
            try await action()
        }
    }
}
