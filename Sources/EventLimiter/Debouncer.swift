import Foundation

public final class Debouncer {
    private let dueTime: UInt64
    private var task: Task<Void, Never>?

    public init(for dueTime: TimeInterval) {
        self.dueTime = UInt64(dueTime * 1_000_000_000)
    }

    deinit {
        self.task?.cancel()
        self.task = nil
    }

    public func callAsFunction(action: @escaping () async -> Void) {
        self.execute(action: action)
    }

    public func cancel() {
        self.task?.cancel()
        self.task = nil
    }
}

private extension Debouncer {
    func execute(action: @escaping () async -> Void) {
        self.task?.cancel()
        self.task = Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: self.dueTime)
            guard !Task.isCancelled else { return }
            await action()
        }
    }
}
