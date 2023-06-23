import Foundation

public final class Debouncer {
    private let dueTime: UInt64
    private var task: Task<Void, Never>?

    public init(for dueTime: TimeInterval) {
        self.dueTime = UInt64(dueTime * 1_000_000_000)
    }

    deinit {
        self.cancel()
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
        self.task = Task { [dueTime] in
            do {
                try await Task.sleep(nanoseconds: dueTime)
            } catch {
                return
            }
            guard !Task.isCancelled else { return }
            await action()
        }
    }
}
