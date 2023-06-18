import Foundation

public final class Throttler {
    private let dueTime: UInt64
    private let latest: Bool
    private var task: Task<Void, Never>?
    private var action: (() async -> Void)?

    public init(for dueTime: TimeInterval, latest: Bool = true) {
        self.dueTime = UInt64(dueTime * 1_000_000_000)
        self.latest = latest
    }

    deinit {
        self.task?.cancel()
        self.task = nil
        self.action = nil
    }

    public func callAsFunction(
        action: @escaping () async -> Void
    ) {
        self.execute(action: action)
    }

    public func cancel() {
        self.task?.cancel()
        self.task = nil
        self.action = nil
    }
}

private extension Throttler {
    func execute(
        action: @escaping () async -> Void
    ) {
        if self.latest {
            self.action = action
        }
        guard self.task?.isCancelled ?? true else { return }

        Task {
            await action()
        }
        self.action = nil

        self.task = Task {
            try? await Task.sleep(nanoseconds: self.dueTime)

            if self.latest, let action = self.action {
                await action()
                self.action = nil
            }
            self.task?.cancel()
        }
    }
}
